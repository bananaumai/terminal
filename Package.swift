// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "BTerm",
    platforms: [.macOS(.v14)],
    products: [
        .executable(name: "BTerm", targets: ["BTerm"])
    ],
    dependencies: [
        .package(url: "https://github.com/migueldeicaza/SwiftTerm.git", branch: "main")
    ],
    targets: [
        .executableTarget(
            name: "BTerm",
            dependencies: ["SwiftTerm"],
            swiftSettings: [.swiftLanguageMode(.v5)]
        ),
        .testTarget(
            name: "BTermTests",
            dependencies: ["BTerm"]
        )
    ]
)
