#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Build Android APK via CMake + optional auto-sign"""

import argparse
import getpass
import json
import os
import re
import shutil
import subprocess
import sys
from pathlib import Path

# --------------------- Config ---------------------
DEFAULT_CONFIG = {
    "project_name": "PainAnalyzer",
    "source_dir": "patient",
    "build_type": "debug",
    "build_dir_debug": "cmake-build-debug-android",
    "build_dir_release": "cmake-build-release-android",
    "install": True,
    "auto_sign_release": True,
    "cmake_defines_common": {
        "QT_HOST_PATH": "",
        "QT_ANDROID_SDK_ROOT": "",
        "QT_ANDROID_NDK_ROOT": "",
        "ANDROID_SDK_ROOT": "",
        "CMAKE_TOOLCHAIN_FILE": "",
        "ANDROID_ABI": "arm64-v8a",
        "ANDROID_PLATFORM": "android-35",
        "CMAKE_PREFIX_PATH": "",
        "QT_ANDROID_MIN_SDK_VERSION": "26",
        "CMAKE_FIND_ROOT_PATH_MODE_PACKAGE": "BOTH",
        "QT_ANDROID_BUILD_TOOLS_REVISION": "35.0.0",
        "BUILD_FRONTEND": "ON"
    },
    "cmake_defines_debug": {},
    "cmake_defines_release": {}
}

# --------------------- Helpers ---------------------
def run(cmd, **kwargs):
    print(f"\n$ {' '.join(map(str, cmd))}")
    return subprocess.run(list(map(str, cmd)), text=True, **kwargs)

def fail(msg, code=1):
    sys.exit(f"❌ {msg}")

def merge_dicts(a, b):
    out = dict(a)
    for k, v in (b or {}).items():
        out[k] = merge_dicts(out[k], v) if isinstance(v, dict) and isinstance(out.get(k), dict) else v
    return out

def has_adb_device():
    if not shutil.which("adb"):
        return False
    p = run(["adb", "devices"], check=False, capture_output=True)
    return p.returncode == 0 and any(re.search(r"\bdevice$", line) for line in p.stdout.splitlines())

def find_apk(build_dir, build_type):
    apks = list(build_dir.rglob("*.apk"))
    if not apks:
        return None
    bt = build_type.lower()
    def score(p):
        s = str(p).lower()
        return (0 if bt in s else 1, 0 if "outputs/apk" in s else 1, 0 if "unsigned" not in s else 1, len(s))
    return sorted(apks, key=score)[0]

def find_apksigner(sdk_root, explicit=""):
    if explicit and Path(explicit).is_file():
        return explicit
    sdk = Path(sdk_root)
    if not sdk.exists():
        fail("ANDROID_SDK_ROOT не найден")
    bt_dir = sdk / "build-tools"
    if not bt_dir.exists():
        fail(f"build-tools не найдена: {bt_dir}")
    candidates = [d / "apksigner" for d in bt_dir.iterdir() if d.is_dir() and (d / "apksigner").is_file()]
    if not candidates:
        fail(f"apksigner не найден в {bt_dir}")
    return str(sorted(candidates)[-1])

def sign_apk(apksigner, unsigned_apk, out_apk, keystore, alias, storepass, keypass):
    if not Path(keystore).is_file():
        fail(f"Keystore не найден: {keystore}")
    if not alias:
        fail("Не задан alias для keystore")
    env = os.environ.copy()
    cmd = [apksigner, "sign", "--ks", keystore, "--ks-key-alias", alias, "--out", str(out_apk)]
    if storepass:
        env["APKSIGNER_STOREPASS"] = storepass
        cmd += ["--ks-pass", "env:APKSIGNER_STOREPASS"]
    if keypass:
        env["APKSIGNER_KEYPASS"] = keypass
        cmd += ["--key-pass", "env:APKSIGNER_KEYPASS"]
    print(f"✍️  Подписываем: {unsigned_apk} → {out_apk}")
    run(cmd, check=True, env=env)

# --------------------- Config ---------------------
def load_config(script_dir):
    cfg_path = script_dir / "android_build_config.json"
    if not cfg_path.exists():
        cfg_path.write_text(json.dumps(DEFAULT_CONFIG, indent=2, ensure_ascii=False) + "\n")
        fail(f"Создан шаблон конфига: {cfg_path}. Отредактируй и запусти снова.")
    try:
        user_cfg = json.loads(cfg_path.read_text(encoding="utf-8"))
    except json.JSONDecodeError as e:
        fail(f"Ошибка в JSON {cfg_path}: {e}")
    return merge_dicts(DEFAULT_CONFIG, user_cfg)

def resolve_config(cfg, script_dir, build_type_override):
    cfg = dict(cfg)
    bt = (build_type_override or cfg.get("build_type", "debug")).lower()
    if bt not in ("debug", "release"):
        fail('build_type должен быть "debug" или "release"')
    cfg["build_type"] = bt
    src = Path(cfg.get("source_dir", "."))
    cfg["source_dir"] = str((script_dir / src).resolve() if not src.is_absolute() else src)
    bdir_key = f"build_dir_{bt}"
    bdir = Path(cfg.get(bdir_key, ""))
    if not str(bdir):
        fail(f"Не задан {bdir_key} в конфиге")
    cfg["build_dir"] = str((script_dir / bdir).resolve() if not bdir.is_absolute() else bdir)
    return cfg

def parse_args():
    parser = argparse.ArgumentParser(description="Build Qt Android APK via CMake + auto-sign")
    parser.add_argument("--debug", action="store_true")
    parser.add_argument("--release", action="store_true")
    parser.add_argument("--build-type", choices=["debug", "release"])
    parser.add_argument("--reconfigure", action="store_true")
    parser.add_argument("--install", action="store_true")
    parser.add_argument("--target", help="CMake target for APK build")
    parser.add_argument("--no-sign", action="store_true")
    return parser.parse_args()

# --------------------- Build Steps ---------------------
def cmake_configure(build_dir, source_dir, cfg):
    """Configure CMake if not already configured."""
    if (build_dir / "CMakeCache.txt").exists():
        return
    print(f"🛠  Configure CMake: {build_dir}")
    build_dir.mkdir(parents=True, exist_ok=True)
    build_type = cfg["build_type"]
    defines = dict(cfg.get("cmake_defines_common", {}))
    defines.update(cfg.get(f"cmake_defines_{build_type}", {}))
    defines["CMAKE_BUILD_TYPE"] = build_type.capitalize()
    d_args = [f"-D{k}={v}" for k, v in defines.items()]
    run(["cmake", "-S", source_dir, "-B", str(build_dir), *d_args], check=True)

def cmake_build(build_dir):
    """Build the project."""
    print("🔨 Сборка проекта...")
    run(["cmake", "--build", str(build_dir), "--parallel"], check=True)

def cmake_build_apk(build_dir, apk_target):
    """Build APK via CMake target."""
    if not apk_target:
        fail("Укажи --target для сборки APK")
    print(f"📦 Создаём APK: {apk_target}")
    run(["cmake", "--build", str(build_dir), "--target", apk_target, "--parallel"], check=True)

def maybe_reconfigure(build_dir, reconfigure):
    """Delete CMakeCache if reconfigure requested."""
    if reconfigure:
        cache = build_dir / "CMakeCache.txt"
        if cache.exists():
            print(f"♻️  Удаляем {cache}")
            cache.unlink()

def get_keystore_params(cfg):
    """Get keystore params from env or config, prompting if missing."""
    ks_path = os.environ.get("ANDROID_KEYSTORE_PATH") or cfg.get("keystore_path", "").strip()
    ks_alias = os.environ.get("ANDROID_KEYSTORE_ALIAS") or cfg.get("keystore_alias", "").strip()
    storepass = os.environ.get("ANDROID_KEYSTORE_STOREPASS") or cfg.get("keystore_storepass", "").strip() or None
    keypass = os.environ.get("ANDROID_KEYSTORE_KEYPASS") or cfg.get("keystore_keypass", "").strip() or None

    if not ks_path:
        fail("Не задан ANDROID_KEYSTORE_PATH")
    if not ks_alias:
        fail("Не задан ANDROID_KEYSTORE_ALIAS")
    if not storepass:
        storepass = getpass.getpass("Keystore password: ")
    if not keypass:
        keypass = getpass.getpass("Key password [Enter = same]: ") or storepass

    return ks_path, ks_alias, storepass, keypass

def maybe_sign_apk(apk, build_type, cfg, no_sign):
    """Sign APK if release + unsigned + auto-sign enabled."""
    if not (build_type == "release" and not no_sign and cfg.get("auto_sign_release", True)):
        return apk
    if "unsigned" not in apk.name.lower():
        return apk

    sdk_root = os.environ.get("ANDROID_SDK_ROOT", "")
    if not sdk_root:
        fail("ANDROID_SDK_ROOT не задан")

    apksigner = find_apksigner(sdk_root, cfg.get("apksigner_path", ""))
    ks_path, ks_alias, storepass, keypass = get_keystore_params(cfg)

    signed_apk = apk.parent / apk.name.replace("-unsigned", "-signed")
    sign_apk(apksigner, apk, signed_apk, ks_path, ks_alias, storepass, keypass)

    if not signed_apk.exists():
        fail(f"Подписанный APK не найден: {signed_apk}")

    print(f"✅ SIGNED APK: {signed_apk}")
    return signed_apk

def maybe_install_apk(apk, do_install):
    """Install APK via adb if requested."""
    if not do_install:
        return
    if not has_adb_device():
        print(f"⚠️ adb не видит устройство. Установи вручную:\n   adb install -r '{apk}'")
        return
    print("📲 Устанавливаем APK...")
    run(["adb", "install", "-r", str(apk)], check=True)
    print("✅ Готово")

# --------------------- Main ---------------------
def main():
    args = parse_args()
    script_dir = Path(__file__).resolve().parent

    bt_override = args.build_type or ("debug" if args.debug else "release" if args.release else None)
    cfg = resolve_config(load_config(script_dir), script_dir, bt_override)

    build_type = cfg["build_type"]
    build_dir = Path(cfg["build_dir"])
    do_install = args.install or cfg.get("install", False)

    maybe_reconfigure(build_dir, args.reconfigure)
    cmake_configure(build_dir, ".", cfg)
    cmake_build(build_dir)
    cmake_build_apk(build_dir, args.target)

    apk = find_apk(build_dir, build_type)
    if not apk:
        fail(f"APK не найден в {build_dir}")
    print(f"✅ APK: {apk}")

    final_apk = maybe_sign_apk(apk, build_type, cfg, args.no_sign)
    maybe_install_apk(final_apk, do_install)

if __name__ == "__main__":
    try:
        main()
    except subprocess.CalledProcessError as e:
        fail(f"Команда завершилась с ошибкой (код {e.returncode})", e.returncode)
    except KeyboardInterrupt:
        fail("Прервано пользователем", 130)