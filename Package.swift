// swift-tools-version:5.9

import PackageDescription

let package = Package(
    name: "ExpandableNavigation",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "ExpandableNavigation",
            targets: ["ExpandableNavigation"]),
    ],
    dependencies: [
        // Ajoutez ici vos dépendances
    ],
    targets: [
        .target(
            name: "ExpandableNavigation",
            dependencies: []),
        .testTarget(
            name: "ExpandableNavigationTests",
            dependencies: ["ExpandableNavigation"],
            path: "ExpandableNavigationTests"),
        .testTarget(
            name: "ExpandableNavigationUITests",
            dependencies: ["ExpandableNavigation"],
            path: "ExpandableNavigationUITests"),
    ]
)
