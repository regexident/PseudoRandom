// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PseudoRandom",
    products: [
        .library(
            name: "PseudoRandom",
            targets: [
                "PseudoRandom",
            ]
        ),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "PseudoRandom",
            dependencies: [
            ]
        ),
        .testTarget(
            name: "PseudoRandomTests",
            dependencies: [
                "PseudoRandom",
            ]
        ),
    ]
)
