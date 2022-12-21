// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ArchitectureDemo",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(name: "TabBar", targets: ["TabBar"]),
        .library(name: "Characters", targets: ["Characters"]),
        .library(name: "Events", targets: ["Events"]),
        .library(name: "Favorites", targets: ["Favorites"]),
        .library(name: "SwiftUIHelpers", targets: ["SwiftUIHelpers"]),
        .library(name: "APIClient", targets: ["APIClient"]),
        .library(name: "SharedModels", targets: ["SharedModels"]),
        .library(name: "AsyncImage", targets: ["AsyncImage"]),
        .library(name: "Mocks", targets: ["Mocks"]),
        .library(name: "Notification", targets: ["Notification"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-collections.git",
                 .upToNextMinor(from: "1.0.0")),
        .package(url: "https://github.com/ably/ably-cocoa", from: "1.2.19")
    ],
    targets: [
        .target(name: "TabBar",
                dependencies: [
                    "Characters",
                    "Favorites",
                    "Events"
                ]),
        .target(name: "Characters",
                dependencies: [
                    "SwiftUIHelpers",
                    "SharedModels",
                    "APIClient",
                    "Favorites",
                    "Mocks",
                    .product(name: "Collections", package: "swift-collections")
                ]),
        .testTarget(name: "CharactersTests",
                    dependencies: [
                        "Characters",
                        "APIClient"
                    ]),
        .target(name: "Events",
                dependencies: [
                    "Favorites",
                    "SharedModels",
                    "SwiftUIHelpers",
                    "APIClient",
                    "Mocks"
                ]),
        .target(name: "Favorites",
                dependencies: [
                    "SharedModels",
                    "SwiftUIHelpers",
                ]),
        .testTarget(name: "FavoritesTests",
                    dependencies: [
                        "Favorites"
                    ]),
        .target(name: "SwiftUIHelpers",
                dependencies: [
                    "AsyncImage"
                ]),
        .target(name: "APIClient",
                dependencies: ["SharedModels"]),
        .testTarget(name: "APIClientTests",
                    dependencies:[
                        "APIClient",
                        "SharedModels"
                    ]),
        .target(name: "SharedModels"),
        .target(name: "AsyncImage"),
        .testTarget(name: "AsyncImageTests",
                    dependencies: [
                        "AsyncImage"
                    ]),
        .target(name: "Mocks",
                dependencies: [
                    "SharedModels"
                ],
                resources: [.process("Resources/")
                           ]),
        .target(name: "Notification",
                dependencies: [
                    "SharedModels",
                    "Mocks",
                    .product(name: "Ably", package: "ably-cocoa")
                ])
    ]
)
