// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "vapor-forwarded-host",
    platforms: [
       .macOS(.v10_15)
    ],
    products: [
        .library(name: "VaporForwardedHost", targets: ["VaporForwardedHost"]),
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "4.77.1"),
    ],
    targets: [
        .target(
            name: "VaporForwardedHost",
            dependencies: [
                .product(name: "Vapor", package: "vapor")
            ]
        ),
        .testTarget(name: "VaporForwardedHostTests", dependencies: [
            .target(name: "VaporForwardedHost"),
            .product(name: "Vapor", package: "vapor"),
            .product(name: "XCTVapor", package: "vapor"),
        ])
    ]
)
