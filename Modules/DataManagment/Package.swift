// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "DataManagment",
    platforms: [.iOS(.v15), .macOS(.v13)],
    products: [.library(name: "DataManagment", targets: ["DataManagment"])],
    targets: [
        .target(name: "DataManagment"),
        .testTarget(name: "DataManagmentTests", dependencies: ["DataManagment"])
    ]
)
