// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "VeoUI",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "VeoUI",
            targets: ["VeoUI"])
    ],
    targets: [
        .target(
            name: "VeoUI",
            resources: [
                .process("Resources")
            ]),
        .testTarget(
            name: "VeoUITests",
            dependencies: ["VeoUI"])
    ])
