// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Concerta",
    platforms: [
        .macOS(.v13),
    ],
    products: [
        .executable(name: "Concerta", targets: ["Concerta"]),
    ],
    targets: [
        .executableTarget(name: "Concerta"),
    ],
    swiftLanguageModes: [.v5]
)
