#!/usr/bin/env python3
import argparse
import shutil
import subprocess
from dbm import dumb
from pathlib import Path
import json
import os
def run(cmd, **kwargs):
    print("\n$", " ".join(map(str, cmd)))
    subprocess.run([str(x) for x in cmd], check=True, **kwargs)


def check_config(config : dict):
    for key,value in config.items():
        if type(value) == str and value == "":
            print(f"{key} not found")
            print("Set the value in the android_build_config.json")
            exit(0)
        if type(value) == dict:
            check_config(value)
    return config
def load_config(root: Path) -> dict:
    path = root / "android_build_config.json"
    with (path).open(encoding="utf-8") as f:
        config = json.load(f)
        return check_config(config)

def resolve_paths(root: Path, cfg: dict):
    build_type = cfg["build_type"].lower()

    if build_type not in ("debug", "release"):
        raise SystemExit("build_type должен быть debug или release")

    source = Path(cfg.get("source_dir", "."))
    source = source if source.is_absolute() else root / source

    build = Path(cfg[f"build_dir_{build_type}"])
    build = build if build.is_absolute() else root / build

    return source.resolve(), build.resolve(), build_type.capitalize()


def conan_install(source: Path, build: Path, cfg: dict, build_type: str):
    c = cfg["cmake_defines_common"]

    profile = Path(c["CONAN_PROFILE"])
    if not profile.is_absolute():
        profile = source / profile

    options = []

    if c.get("BUILD_FRONTEND") == "ON":
        options += ["-o", "with_client=True", "-o", "with_server=False"]

    if c.get("BUILD_BACKEND") == "ON":
        options += ["-o", "with_client=False", "-o", "with_server=True"]

    run([
        c["CONAN_CMD"],
        "install",
        source,
        "--output-folder", build,
        "--profile:host", profile,
        "--build=missing",
        "-s", f"build_type={build_type}",
        *options,
    ])

def cmake_configure(source: Path, build: Path, cfg: dict, build_type: str):
    c = cfg["cmake_defines_common"]

    qt = Path(c["CMAKE_PREFIX_PATH"])
    toolchain = build / "conan_toolchain.cmake"

    if not toolchain.exists():
        raise SystemExit(f"Не найден Conan toolchain: {toolchain}")

    defines = {
        "CMAKE_BUILD_TYPE": build_type,

        # Единственный toolchain CMake.
        "CMAKE_TOOLCHAIN_FILE": toolchain,

        # Qt Android.
        "CMAKE_PREFIX_PATH": qt,
        "Qt6_DIR": qt / "lib/cmake/Qt6",
        "CMAKE_FIND_ROOT_PATH_MODE_PACKAGE": "ONLY",

        "QT_HOST_PATH": c["QT_HOST_PATH"],
        "ANDROID_SDK_ROOT": c["ANDROID_SDK_ROOT"],
        "ANDROID_NDK_ROOT": c["ANDROID_NDK_ROOT"],
        "QT_ANDROID_MIN_SDK_VERSION":
            c.get("QT_ANDROID_MIN_SDK_VERSION", "26"),
        "QT_ANDROID_BUILD_TOOLS_REVISION":
            c.get("QT_ANDROID_BUILD_TOOLS_REVISION", ""),

        "ANDROID_ABI": c.get("ANDROID_ABI", "arm64-v8a"),

        "BUILD_FRONTEND": c.get("BUILD_FRONTEND", "OFF"),
        "BUILD_BACKEND": c.get("BUILD_BACKEND", "OFF"),
    }

    build.mkdir(parents=True, exist_ok=True)

    run([
        "cmake",
        "-S", source,
        "-B", build,
        *[
            f"-D{name}={value}"
            for name, value in defines.items()
            if value != ""
        ],
    ])

def package_apk(build: Path, cfg: dict):
    c = cfg["cmake_defines_common"]

    androiddeployqt = (
            Path(c["QT_HOST_PATH"])
            / "bin"
            / "androiddeployqt"
    )

    deployment = (
            build
            / "frontend"
            / "patient"
            / "android-patient-deployment-settings.json"
    )

    if not androiddeployqt.exists():
        raise SystemExit(
            f"Не найден androiddeployqt:\n{androiddeployqt}"
        )

    if not deployment.exists():
        raise SystemExit(
            f"Не найден deployment settings:\n{deployment}"
        )
    with deployment.open("r", encoding="utf-8") as f:
        deployment_data = json.load(f)

    deployment_data["extraLibraryDirs"] = [
        path
        for path in deployment_data.get("extraLibraryDirs", [])
        if ".conan2/p/b/opens" not in path
    ]

    with deployment.open("w", encoding="utf-8") as f:
        json.dump(
            deployment_data,
            f,
            indent=2,
            ensure_ascii=False
        )

    print("Filtered Android deployment extraLibraryDirs:")
    for path in deployment_data.get("extraLibraryDirs", []):
        print("  ", path)

    run([
        androiddeployqt,
        "--input", deployment,
        "--output", deployment.parent,
        "--android-platform", "android-36",
        "--gradle",
    ])
def find_apk(build: Path, build_type: str) -> Path:
    apks = list(build.rglob("*.apk"))

    if not apks:
        raise SystemExit(f"APK не найден в {build}")

    build_type = build_type.lower()

    apks.sort(key=lambda p: (
        build_type not in str(p).lower(),
        "outputs/apk" not in str(p),
        "unsigned" in p.name.lower(),
        len(str(p)),
    ))

    return apks[0]


def install_apk(apk: Path):
    if not shutil.which("adb"):
        print(f"⚠️ adb не найден. Установи вручную:\n"
              f"   adb install -r '{apk}'")
        return

    result = subprocess.run(
        ["adb", "devices"],
        text=True,
        capture_output=True,
        check=False,
    )

    device_found = any(
        line.endswith("\tdevice")
        for line in result.stdout.splitlines()
    )

    if not device_found:
        print(f"⚠️ Устройство не найдено. Установи вручную:\n"
              f"   adb install -r '{apk}'")
        return

    run(["adb", "install", "-r", apk])


def main():
    parser = argparse.ArgumentParser(description="Build Qt Android APK")

    parser.add_argument(
        "--build-type",
        choices=["debug", "release"],
    )
    parser.add_argument(
        "--target",
        required=True,
        help="CMake target для APK",
    )
    parser.add_argument(
        "--reconfigure",
        action="store_true",
        help="Удалить старый CMake build и сконфигурировать заново",
    )
    parser.add_argument(
        "--install",
        action="store_true",
        help="Установить APK через adb",
    )

    args = parser.parse_args()

    root = Path(__file__).resolve().parent
    cfg = load_config(root)

    if args.build_type:
        cfg["build_type"] = args.build_type

    source, build, build_type = resolve_paths(root, cfg)

    if args.reconfigure and build.exists():
        print(f"♻️ Удаляем {build}")
        shutil.rmtree(build)

    need_configure = not (build / "CMakeCache.txt").exists()

    if need_configure:
        print("🔧 Первый запуск: устанавливаем Conan dependencies...")
        conan_install(source, build, cfg, build_type)

        print("🔧 Конфигурируем CMake...")
        cmake_configure(source, build, cfg, build_type)
    else:
        print("♻️ Используем существующий CMake/Conan build")
    run([
        "cmake",
        "--build",
        build,
        "--target",
        args.target,
        "--parallel",
    ])
    package_apk(build, cfg)
    apk = find_apk(build, build_type)

    print(f"\n✅ APK: {apk}")

    if args.install or cfg.get("install", False):
        install_apk(apk)


if __name__ == "__main__":
    main()