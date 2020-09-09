// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "Toolbox",
    platforms: [
        .iOS(.v12)
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
