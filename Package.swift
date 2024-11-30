// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "StringsCatalogKit",
    platforms: [.macOS(.v15)],
    products: [
        .library(
            name: "StringsCatalogKit",
            targets: ["StringsCatalogKit"]),
        .executable(
            name: "strings_catalog_tool",
            targets: ["strings_catalog_tool"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.5.0"),
    ],
    targets: [
        .target(
            name: "StringsCatalogKit",
            swiftSettings: [
                .unsafeFlags(["-warnings-as-errors"], .when(configuration: .debug)),
            ]),
        .executableTarget(
            name: "strings_catalog_tool",
            dependencies: [
                "StringsCatalogKit",
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ],
            path: "Sources/Tool",
            swiftSettings: [
                .unsafeFlags(["-warnings-as-errors"], .when(configuration: .debug)),
            ]
        ),
        .testTarget(
            name: "StringsCatalogKitTests",
            dependencies: ["StringsCatalogKit"],
            resources: [
                .process("TestData/LocalizableBase.xcstrings")
            ]
        ),
    ]
)
