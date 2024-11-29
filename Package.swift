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
    ],
    targets: [
        .target(
            name: "StringsCatalogKit"),
        .testTarget(
            name: "StringsCatalogKitTests",
            dependencies: ["StringsCatalogKit"],
            resources: [
                .process("TestData/LocalizableBase.xcstrings")
            ]
        ),
    ]
)
