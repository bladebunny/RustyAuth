// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RustyAuth",
    platforms: [
        .macOS(.v10_15), .iOS(.v13), .tvOS(.v13)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "RustyAuth",
            targets: ["RustyAuth"]),
    ],
    dependencies: [
        //.package(path: "/Users/tim.a.brooks/Documents/Source/Libs/RustyExtensions"),
        .package(url: "https://github.com/bladebunny/RustyExtensions", branch: "main")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "RustyAuth",
            dependencies: ["RustyExtensions"]),
        .testTarget(
            name: "RustyAuthTests",
            dependencies: ["RustyAuth"]),
    ]
)
