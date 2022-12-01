// swift-tools-version: 5.5

import PackageDescription

let package = Package(
    name: "OSInfo",
    products: [
        .library(
            name: "OSInfo",
            targets: ["OSInfo"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "OSInfo",
            dependencies: []
        ),
        .testTarget(
            name: "OSInfoTests",
            dependencies: ["OSInfo"]
        ),
    ]
)
