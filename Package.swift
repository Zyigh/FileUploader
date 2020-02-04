// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "fileuploader",
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/IBM-Swift/Kitura.git", from: "2.9.1"),
        .package(url: "https://github.com/IBM-Swift/HeliumLogger.git", from: "1.9.0"),
        .package(url: "https://github.com/IBM-Swift/Kitura-Compression.git", from: "2.2.2"),
        .package(url: "https://github.com/IBM-Swift/Kitura-StencilTemplateEngine.git", from: "1.11.1"),
        .package(url: "https://github.com/IBM-Swift/Kitura-Session.git", from: "3.3.4"),
        .package(url: "https://github.com/SwiftOnTheServer/SwiftDotEnv.git", from: "2.0.1"),
        .package(url: "https://github.com/IBM-Swift/Swift-Kuery-SQLite.git", from: "2.0.1")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "fileuploader",
            dependencies: ["Kitura", "HeliumLogger", "KituraCompression", "KituraStencil", "KituraSession", "SwiftDotEnv", "SwiftKuerySQLite"]),
        .testTarget(
            name: "fileuploaderTests",
            dependencies: ["fileuploader"]),
    ]
)
