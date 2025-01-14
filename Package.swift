// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "Toolbox",
    platforms: [
        .iOS(.v14),
        .macOS(.v11)
    ],
    products: [
        .library(
            name: "Toolbox",
            targets: ["Toolbox"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-async-algorithms.git", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "Toolbox",
            dependencies: [
                .product(name: "AsyncAlgorithms", package: "swift-async-algorithms"),
            ]),
        .testTarget(
            name: "ToolboxTests",
            dependencies: ["Toolbox"]),
    ],
    swiftLanguageVersions: [.v5]
)
