#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../../.." && pwd)"
PACKAGE_DIR="$ROOT_DIR/packages/swift/EchoButlerSDK"
ARTIFACT_DIR="$PACKAGE_DIR/Artifacts"
BUILD_DIR="$PACKAGE_DIR/.build/ffi"
HEADER_DIR="$PACKAGE_DIR/CHeaders"

IOS_DEVICE_TARGET="aarch64-apple-ios"
IOS_SIM_TARGETS=("aarch64-apple-ios-sim" "x86_64-apple-ios")
MACOS_TARGETS=("aarch64-apple-darwin" "x86_64-apple-darwin")

rm -rf "$ARTIFACT_DIR/EchoButlerFFI.xcframework" "$BUILD_DIR"
mkdir -p "$ARTIFACT_DIR" "$BUILD_DIR/ios-simulator" "$BUILD_DIR/macos"

export IPHONEOS_DEPLOYMENT_TARGET="${IPHONEOS_DEPLOYMENT_TARGET:-15.0}"
export MACOSX_DEPLOYMENT_TARGET="${MACOSX_DEPLOYMENT_TARGET:-12.0}"

build_target() {
  local target="$1"
  rustup target add "$target"
  cargo build -p echobutler-ffi --release --target "$target"
}

build_target "$IOS_DEVICE_TARGET"
for target in "${IOS_SIM_TARGETS[@]}"; do
  build_target "$target"
done
for target in "${MACOS_TARGETS[@]}"; do
  build_target "$target"
done

lipo -create \
  "$ROOT_DIR/target/aarch64-apple-ios-sim/release/libechobutler_ffi.a" \
  "$ROOT_DIR/target/x86_64-apple-ios/release/libechobutler_ffi.a" \
  -output "$BUILD_DIR/ios-simulator/libechobutler_ffi.a"

lipo -create \
  "$ROOT_DIR/target/aarch64-apple-darwin/release/libechobutler_ffi.a" \
  "$ROOT_DIR/target/x86_64-apple-darwin/release/libechobutler_ffi.a" \
  -output "$BUILD_DIR/macos/libechobutler_ffi.a"

xcodebuild -create-xcframework \
  -library "$ROOT_DIR/target/aarch64-apple-ios/release/libechobutler_ffi.a" \
  -headers "$HEADER_DIR" \
  -library "$BUILD_DIR/ios-simulator/libechobutler_ffi.a" \
  -headers "$HEADER_DIR" \
  -library "$BUILD_DIR/macos/libechobutler_ffi.a" \
  -headers "$HEADER_DIR" \
  -output "$ARTIFACT_DIR/EchoButlerFFI.xcframework"
