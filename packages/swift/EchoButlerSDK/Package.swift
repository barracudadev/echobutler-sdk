// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "EchoButlerSDK",
    platforms: [
        .iOS(.v15),
        .macOS(.v12)
    ],
    products: [
        .library(
            name: "EchoButlerSDK",
            targets: ["EchoButlerSDK"]
        )
    ],
    targets: [
        .binaryTarget(
            name: "EchoButlerFFI",
            path: "Artifacts/EchoButlerFFI.xcframework"
        ),
        .target(
            name: "EchoButlerSDK",
            dependencies: ["EchoButlerFFI"]
        ),
        .testTarget(
            name: "EchoButlerSDKTests",
            dependencies: ["EchoButlerSDK"]
        )
    ]
)
