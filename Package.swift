// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "DependencyInjector",
    products: [
        .library(
            name: "DependencyInjector",
            targets: ["DependencyInjector"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "DependencyInjector",
            dependencies: [
            ]),
        .testTarget(
            name: "DependencyInjectorTests",
            dependencies: ["DependencyInjector"])
    ]
)
