// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CoachCroweBasic",
    platforms: [.iOS(.v15)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "CoachCroweBasic",
            targets: ["CoachCroweBasic"]),
    ],
    dependencies: [
        .package(url: "https://github.com/leancloud/swift-sdk", .upToNextMajor(from: "17.11.0")),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "CoachCroweBasic",
            dependencies: [
                .product(name: "LeanCloud", package: "swift-sdk")
            ],
        path: "Sources"
        )
    ]
)
