#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
Build Android APK via CMake targets (Qt/Android CMake integration) + optional auto-sign.

Pipeline:
1) Configure CMake (if needed)
2) Build native/default targets
3) Build APK via CMake target (PainAnalyzer_make_apk / apk_all / apk)
4) Find resulting APK
5) If release+unsigned (or explicitly enabled): sign with apksigner
6) Optionally install via adb

Signing:
- Uses Android build-tools apksigner from ANDROID_SDK_ROOT (or config path)
- Keystore params come from config OR environment variables:
  ANDROID_KEYSTORE_PATH, ANDROID_KEYSTORE_ALIAS, ANDROID_KEYSTORE_STOREPASS, ANDROID_KEYSTORE_KEYPASS
  (storepass/keypass can also be provided interactively if not set)
"""

import argparse
import getpass
import json
import os
import re
import shutil
import subprocess
import sys
from pathlib import Path

# --------------------- helpers ---------------------
def run(cmd, *, check=True, capture_output=False, text=True, cwd=None):
    print("\n$ " + " ".join(map(str, cmd)))
    return subprocess.run(
        list(map(str, cmd)),
        check=check,
        capture_output=capture_output,
        text=text,
        cwd=cwd,
    )

def fail(msg, code=1):
    print(msg, file=sys.stderr)
    sys.exit(code)

def read_text(path: Path) -> str:
    return path.read_text(encoding="utf-8", errors="ignore")

def write_text(path: Path, data: str):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(data, encoding="utf-8")

def deep_merge_dict(a: dict, b: dict) -> dict:
    out = dict(a)
    for k, v in (b or {}).items():
        if isinstance(v, dict) and isinstance(out.get(k), dict):
            out[k] = deep_merge_dict(out[k], v)
        else:
            out[k] = v
    return out

def adb_has_device() -> bool:
    if not shutil.which("adb"):
        return False
    p = run(["adb", "devices"], check=False, capture_output=True)
    if p.returncode != 0:
        return False
    for line in (p.stdout or "").splitlines():
        if re.search(r"\bdevice$", line.strip()):
            return True
    return False

def cmake_cache_exists(build_dir: Path) -> bool:
    return (build_dir / "CMakeCache.txt").exists()

def list_cmake_targets(build_dir: Path) -> list[str]:
    p = run(["cmake", "--build", str(build_dir), "--target", "help"], check=False, capture_output=True)
    out = (p.stdout or "") + "\n" + (p.stderr or "")
    targets = set()
    for line in out.splitlines():
        line = line.strip()
        if not line:
            continue
        m = re.match(r"^\.\.\.\s+([A-Za-z0-9_.:+-]+)$", line)
        if m:
            targets.add(m.group(1))
            continue
        m = re.match(r"^([A-Za-z0-9_.:+-]+)\s*:", line)
        if m and "CMakeFiles" not in line:
            targets.add(m.group(1))
    return sorted(targets)

def pick_apk_target(project_name: str, targets: list[str]) -> str:
    preferred = [
        f"{project_name}_make_apk",
        "apk_all",
        "apk",
    ]
    for t in preferred:
        if t in targets:
            return t
    return ""

def find_apk(build_dir: Path, build_type: str) -> str:
    apks = [p for p in build_dir.rglob("*.apk")]
    if not apks:
        return ""

    bt = build_type.lower()

    def score(p: Path):
        s = str(p).lower()
        want = ("release" in s) if bt == "release" else ("debug" in s)
        is_outputs = ("outputs/apk" in s) or ("build/outputs/apk" in s)
        unsigned = ("unsigned" in s)
        # Prefer correct variant, outputs path, and (if possible) signed over unsigned
        return (
            0 if want else 1,
            0 if is_outputs else 1,
            0 if not unsigned else 1,
            len(s),
            s,
        )

    return str(sorted(apks, key=score)[0])

def is_unsigned_apk(apk_path: Path) -> bool:
    return "unsigned" in apk_path.name.lower()

def which_apksigner(sdk_root: str, explicit: str = "") -> str:
    if explicit:
        p = Path(explicit)
        if p.is_file():
            return str(p)
        fail(f"❌ apksigner не найден по пути из конфига: {explicit}")

    sdk = Path(sdk_root) if sdk_root else None
    if not sdk or not sdk.exists():
        fail("❌ ANDROID_SDK_ROOT не задан или указывает на несуществующую папку. Нужен для поиска apksigner.")

    bt_dir = sdk / "build-tools"
    if not bt_dir.exists():
        fail(f"❌ Не найдена папка build-tools: {bt_dir}")

    # choose latest version by sorting (works for typical versions)
    candidates = []
    for vdir in bt_dir.iterdir():
        if vdir.is_dir():
            apksigner = vdir / "apksigner"
            if apksigner.is_file():
                candidates.append(apksigner)

    if not candidates:
        fail(f"❌ apksigner не найден в {bt_dir}/*/apksigner")

    # pick lexicographically last (usually latest)
    candidates_sorted = sorted(candidates, key=lambda p: str(p))
    return str(candidates_sorted[-1])

def apksigner_verify(apksigner: str, apk: Path) -> bool:
    p = run([apksigner, "verify", "--verbose", str(apk)], check=False, capture_output=True)
    return p.returncode == 0

def sign_apk(
        apksigner: str,
        unsigned_apk: Path,
        out_apk: Path,
        keystore_path: str,
        keystore_alias: str,
        storepass: str | None,
        keypass: str | None,
):
    if not Path(keystore_path).is_file():
        fail(f"❌ Keystore не найден: {keystore_path}")
    if not keystore_alias:
        fail("❌ Не задан alias для keystore")

    cmd = [
        apksigner, "sign",
        "--ks", keystore_path,
        "--ks-key-alias", keystore_alias,
        "--out", str(out_apk),
    ]

    # Prefer passing passwords via env to avoid showing in process list
    env = os.environ.copy()
    if storepass:
        env["APKSIGNER_STOREPASS"] = storepass
        cmd += ["--ks-pass", "env:APKSIGNER_STOREPASS"]
    if keypass:
        env["APKSIGNER_KEYPASS"] = keypass
        cmd += ["--key-pass", "env:APKSIGNER_KEYPASS"]

    print(f"✍️  Подписываем APK:\n   in:  {unsigned_apk}\n   out: {out_apk}")
    print("\n$ " + " ".join(map(str, cmd)))
    subprocess.run(list(map(str, cmd)), check=True, env=env)

# --------------------- config ---------------------
DEFAULT_CONFIG = {

        "project_name": "PainAnalyzer",
        "source_dir": ".",

        "build_type": "debug",

        "build_dir_debug": "cmake-build-debug-android",
        "build_dir_release": "cmake-build-release-android",

        "output_dir_debug": "{build_dir}/android-build-debug",
        "output_dir_release": "{build_dir}/android-build-release",
        "android_platform": "android-36",
        "jdk_path": "",
        "androiddeployqt": "",

        "install": True,
        "run": True,

        "cmake_defines_common": {
            "QT_HOST_PATH": "",
            "QT_ANDROID_SDK_ROOT": "",
            "QT_ANDROID_NDK_ROOT": "",
            "CMAKE_TOOLCHAIN_FILE": "",
            "ANDROID_ABI": "arm64-v8a",
            "ANDROID_PLATFORM": "android-35",
            "CMAKE_PREFIX_PATH": "",
            "CMAKE_FIND_ROOT_PATH_MODE_PACKAGE": "BOTH",
            "QT_ANDROID_BUILD_TOOLS_REVISION": "35.0.0",
            "ANDROID_SDK_ROOT": ""
        },

        "cmake_defines_debug": {},
        "cmake_defines_release": {}

}

def load_config(script_dir: Path) -> dict:
    cfg_path = script_dir / "android_build_config.json"
    if not cfg_path.exists():
        write_text(cfg_path, json.dumps(DEFAULT_CONFIG, indent=2, ensure_ascii=False) + "\n")
        fail(f"❌ Не найден конфиг: {cfg_path}\n✅ Создал шаблон. Отредактируй и запусти снова.")
    try:
        user_cfg = json.loads(read_text(cfg_path))
    except json.JSONDecodeError as e:
        fail(f"❌ Ошибка в JSON {cfg_path}: {e}")
    cfg = deep_merge_dict(DEFAULT_CONFIG, user_cfg)
    for k in ("cmake_defines_common", "cmake_defines_debug", "cmake_defines_release"):
        if not isinstance(cfg.get(k), dict):
            cfg[k] = {}
    return cfg

def resolve_paths(cfg: dict, script_dir: Path, build_type_override: str | None) -> dict:
    cfg = dict(cfg)
    bt = (build_type_override or cfg.get("build_type", "debug")).lower().strip()
    if bt not in ("debug", "release"):
        fail('❌ build_type должен быть "debug" или "release"')
    cfg["build_type"] = bt

    src = Path(cfg.get("source_dir", "."))
    if not src.is_absolute():
        src = (script_dir / src).resolve()
    cfg["source_dir"] = str(src)

    bdir_key = "build_dir_release" if bt == "release" else "build_dir_debug"
    bdir = Path(cfg.get(bdir_key, ""))
    if not str(bdir):
        fail(f"❌ Не задан {bdir_key} в конфиге")
    if not bdir.is_absolute():
        bdir = (script_dir / bdir).resolve()
    cfg["build_dir"] = str(bdir)

    return cfg

# --------------------- cli ---------------------
def parse_args():
    p = argparse.ArgumentParser(description="Build Qt Android APK via CMake targets + optional auto-sign.")
    g = p.add_mutually_exclusive_group()
    g.add_argument("--debug", action="store_true", help="Build debug")
    g.add_argument("--release", action="store_true", help="Build release")
    p.add_argument("--build-type", choices=["debug", "release"], help="Override build type")
    p.add_argument("--reconfigure", action="store_true", help="Force CMake reconfigure (delete CMakeCache.txt)")
    p.add_argument("--install", action="store_true", help="Install produced APK via adb")
    p.add_argument("--apk-target", help="Force CMake target to build APK (overrides auto-detect and config)")
    p.add_argument("--no-sign", action="store_true", help="Disable auto-sign even for release")
    return p.parse_args()

# --------------------- main ---------------------
def main():
    args = parse_args()
    script_dir = Path(__file__).resolve().parent
    cfg_raw = load_config(script_dir)

    bt_override = None
    if args.build_type:
        bt_override = args.build_type
    elif args.debug:
        bt_override = "debug"
    elif args.release:
        bt_override = "release"

    cfg = resolve_paths(cfg_raw, script_dir, bt_override)

    project_name = str(cfg.get("project_name", "App"))
    build_type = cfg["build_type"]
    source_dir = Path(cfg["source_dir"])
    build_dir = Path(cfg["build_dir"])

    do_install = bool(args.install or cfg.get("install", False))
    auto_sign_release = bool(cfg.get("auto_sign_release", True)) and not args.no_sign

    # CMake defines
    defines = dict(cfg.get("cmake_defines_common", {}))
    defines.update(cfg.get("cmake_defines_release" if build_type == "release" else "cmake_defines_debug", {}))
    defines["CMAKE_BUILD_TYPE"] = "Release" if build_type == "release" else "Debug"

    # Reconfigure if requested
    if args.reconfigure and build_dir.exists():
        cache = build_dir / "CMakeCache.txt"
        if cache.exists():
            print(f"♻️  Удаляем {cache} (reconfigure)")
            cache.unlink()

    # Configure if needed
    if not cmake_cache_exists(build_dir):
        print(f"🛠  Configure CMake in: {build_dir}")
        build_dir.mkdir(parents=True, exist_ok=True)
        d_args = [f"-D{k}={v}" for k, v in defines.items()]
        run(["cmake", "-S", str(source_dir), "-B", str(build_dir), *d_args])

    # Build project
    print("🔨 Сборка проекта (cmake --build)...")
    run(["cmake", "--build", str(build_dir), "--parallel"])

    # Determine APK CMake target
    forced_target = (args.apk_target or "").strip()
    if forced_target:
        apk_target = forced_target
    else:
        cfg_target = (cfg.get("apk_target_release") if build_type == "release" else cfg.get("apk_target_debug")) or ""
        cfg_target = str(cfg_target).strip()
        if cfg_target:
            apk_target = cfg_target
        else:
            targets = list_cmake_targets(build_dir)
            apk_target = pick_apk_target(project_name, targets)

    if not apk_target:
        fail(
            "❌ Не удалось определить CMake target для сборки APK.\n"
            "👉 Выполни: cmake --build <build_dir> --target help\n"
            "и укажи явно: --apk-target <target>\n"
            "или заполни apk_target_release/apk_target_debug в android_build_config.json"
        )

    # Build APK
    print(f"📦 Создаём APK через CMake target: {apk_target}")
    run(["cmake", "--build", str(build_dir), "--target", apk_target, "--parallel"])

    apk_path = find_apk(build_dir, build_type)
    if not apk_path:
        fail(f"❌ APK не найден в дереве сборки: {build_dir}")
    apk = Path(apk_path)
    print(f"✅ APK: {apk}")

    # Auto-sign release unsigned APK
    final_apk = apk
    if build_type == "release" and auto_sign_release and is_unsigned_apk(apk):
        sdk_root = os.environ.get("ANDROID_SDK_ROOT", "")
        if not sdk_root:
            # You provided ANDROID_SDK_ROOT in chat; still, we require it in env at runtime.
            fail("❌ ANDROID_SDK_ROOT не задан в окружении. Добавь export ANDROID_SDK_ROOT=/home/konstantin/Android/Sdk")

        apksigner = which_apksigner(sdk_root, explicit=str(cfg.get("apksigner_path", "")).strip())
        print(f"🔎 apksigner: {apksigner}")

        # Keystore params: env overrides config
        ks_path = os.environ.get("ANDROID_KEYSTORE_PATH") or str(cfg.get("keystore_path", "")).strip()
        ks_alias = os.environ.get("ANDROID_KEYSTORE_ALIAS") or str(cfg.get("keystore_alias", "")).strip()

        storepass = os.environ.get("ANDROID_KEYSTORE_STOREPASS") or str(cfg.get("keystore_storepass", "")).strip() or None
        keypass = os.environ.get("ANDROID_KEYSTORE_KEYPASS") or str(cfg.get("keystore_keypass", "")).strip() or None

        if not ks_path:
            fail(
                "❌ Не задан путь к keystore.\n"
                "Задай в окружении ANDROID_KEYSTORE_PATH или в конфиге keystore_path."
            )
        if not ks_alias:
            fail(
                "❌ Не задан alias keystore.\n"
                "Задай в окружении ANDROID_KEYSTORE_ALIAS или в конфиге keystore_alias."
            )

        # If passwords not provided, ask interactively
        if storepass is None:
            storepass = getpass.getpass("Keystore password (storepass): ")
        if keypass is None:
            # key password может совпадать со storepass
            keypass_in = getpass.getpass("Key password (keypass) [Enter = same as storepass]: ")
            keypass = keypass_in if keypass_in else storepass

        signed_name = re.sub(r"-unsigned\.apk$", "-signed.apk", apk.name, flags=re.IGNORECASE)
        if signed_name == apk.name:
            signed_name = apk.stem + "-signed.apk"
        signed_apk = apk.parent / signed_name

        sign_apk(
            apksigner=apksigner,
            unsigned_apk=apk,
            out_apk=signed_apk,
            keystore_path=ks_path,
            keystore_alias=ks_alias,
            storepass=storepass,
            keypass=keypass,
        )

        if not signed_apk.exists():
            fail(f"❌ Подписанный APK не найден: {signed_apk}")

        if not apksigner_verify(apksigner, signed_apk):
            fail("❌ apksigner verify не прошёл для подписанного APK")

        print(f"✅ SIGNED APK: {signed_apk}")
        final_apk = signed_apk

    # Install
    if not do_install:
        return 0

    if not adb_has_device():
        print("⚠️ adb не видит устройство. Установка пропущена.")
        print(f"Можно установить вручную: adb install -r '{final_apk}'")
        return 0

    print("📲 Устанавливаем APK...")
    run(["adb", "install", "-r", str(final_apk)])
    print("✅ Готово.")
    return 0

if __name__ == "__main__":
    try:
        sys.exit(main())
    except subprocess.CalledProcessError as e:
        fail(f"❌ Команда завершилась с ошибкой (код {e.returncode}).", code=e.returncode)