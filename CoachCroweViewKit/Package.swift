// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CoachCroweViewKit",
    platforms: [.iOS(.v15)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "CoachCroweViewKit",
            targets: ["CoachCroweViewKit"]),
    ],
    dependencies: [
        .package(path: "../CoachCroweBasic"),
        .package(path: "../CoachCroweViewModels"),
        .package(url: "https://github.com/SDWebImage/SDWebImageSwiftUI", .upToNextMajor(from: "2.2.3"))
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "CoachCroweViewKit",
            dependencies: [
                .product(name: "CoachCroweBasic", package: "CoachCroweBasic"),
                .product(name: "CoachCroweViewModels", package: "CoachCroweViewModels"),
                .product(name: "SDWebImageSwiftUI", package: "SDWebImageSwiftUI")
            ],
            path: "Sources"
        )
    ]
)
