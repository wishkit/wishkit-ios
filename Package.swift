// swift-tools-version:5.6
import PackageDescription

let package = Package(
    name: "wishkit-ios",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(name: "WishKit", targets: ["WishKit"])
    ],
    dependencies: [
        .package(url: "https://github.com/wishkit/wishkit-ios-shared.git", branch: "main")
    ],
    targets: [
        .target(name: "WishKit", dependencies: [
            .product(name: "WishKitShared", package: "wishkit-ios-shared")
        ]),
        .testTarget(name: "WishKitTests", dependencies: [.target(name: "WishKit")]),
    ]
)