// swift-tools-version:5.10
import PackageDescription

let package = Package(
    name: "wishkit-ios",
    defaultLocalization: "en",
    platforms: [
        .macOS(.v12),
        .iOS(.v17)
    ],
    products: [
        .library(name: "WishKit", targets: ["WishKit"])
    ],
    dependencies: [
        .package(url: "https://github.com/wishkit/wishkit-ios-shared.git", exact: "1.5.0")
    ],
    targets: [
        .target(name: "WishKit", dependencies: [
            .product(name: "WishKitShared", package: "wishkit-ios-shared")
        ]),
        .testTarget(name: "WishKitTests", dependencies: [.target(name: "WishKit")]),
    ]
)
