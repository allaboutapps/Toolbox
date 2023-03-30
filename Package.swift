// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "Toolbox",
    platforms: [
        .iOS(.v14),
        .macOS(.v10_15)
    ],
    products: [
        .library(
            name: "Toolbox",
            targets: ["Toolbox"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "Toolbox",
            dependencies: []),
        .testTarget(
            name: "ToolboxTests",
            dependencies: ["Toolbox"]),
    ],
    swiftLanguageVersions: [.v5]
)
