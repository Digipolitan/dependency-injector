// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "DependencyInjector",
    products: [
        .library(name: "DependencyInjector", targets: ["DependencyInjector"])
    ],
    targets: [
        .target(name: "DependencyInjector"),
        .testTarget(
            name: "DependencyInjectorTests",
            dependencies: [
                "DependencyInjector"
            ]
        )
    ]
)
