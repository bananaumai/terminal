// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "tm",
    platforms: [.macOS(.v14)],
    products: [
        .executable(name: "tm", targets: ["TM"])
    ],
    dependencies: [
        .package(url: "https://github.com/migueldeicaza/SwiftTerm.git", branch: "main")
    ],
    targets: [
        .executableTarget(
            name: "TM",
            dependencies: ["SwiftTerm"],
            swiftSettings: [.swiftLanguageMode(.v5)]
        ),
        .testTarget(
            name: "TMTests",
            dependencies: ["TM"]
        )
    ]
)
