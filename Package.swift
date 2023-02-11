// swift-tools-version:5.4
import PackageDescription

let package = Package(
    name: "wishkit-ios",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(name: "WishKit", targets: ["WishKit"])
    ],
    dependencies: [],
    targets: [
        .target(name: "WishKit", dependencies: []),
        .testTarget(name: "WishKitTests", dependencies: [.target(name: "WishKit")]),
    ]
)
