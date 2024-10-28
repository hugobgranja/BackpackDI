// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "BackpackDI",
    platforms: [
        .macOS(.v14),
        .iOS(.v17),
        .tvOS(.v17),
        .watchOS(.v10),
        .visionOS(.v1)
    ],
    products: [
        .library(
            name: "BackpackDI",
            targets: ["BackpackDI"]),
    ],
    targets: [
        .target(
            name: "BackpackDI"
        ),
        .testTarget(
            name: "BackpackDITests",
            dependencies: ["BackpackDI"]
        ),
    ]
)
