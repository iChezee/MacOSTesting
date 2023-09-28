// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "DependencyInjection",
    products: [.library(name: "DependencyInjection", targets: ["DependencyInjection"])],
    dependencies: [.package(url: "https://github.com/Swinject/Swinject.git", from: "2.8.0")],
    targets: [
        .target(name: "DependencyInjection", dependencies: ["Swinject"]),
        .testTarget(name: "DependencyInjectionTests", dependencies: ["DependencyInjection"])
    ]
)
