// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MangaDexAPIKit",
    platforms: [.iOS(.v18), .macOS(.v15)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "MangaDexAPIKit",
            targets: ["MangaDexAPIKit"]),
    ],
    dependencies: [
       .package(
         url: "https://github.com/apple/swift-collections.git",
         .upToNextMinor(from: "1.2.0") // or `.upToNextMajor
       ),
       .package(
        url: "https://github.com/apple/swift-docc-plugin",
        from: "1.1.0"
       )
     ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "MangaDexAPIKit",
            dependencies: [
                   .product(name: "Collections", package: "swift-collections")
                 ]
        ),
        .testTarget(
            name: "MangaDexAPIKitTests",
            dependencies: ["MangaDexAPIKit"]
        ),
    ]
)
