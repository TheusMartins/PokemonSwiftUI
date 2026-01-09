import ProjectDescription

let project = Project(
    name: "PokedexListing",
    targets: [
        .target(
            name: "PokedexListing",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.matheusmartins.PokedexListing",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: [
                .project(target: "CoreNetworking", path: "../../Modules/Core/CoreNetworking"),
                .project(target: "CoreDesignSystem", path: "../../Modules/Core/CoreDesignSystem"),
                .project(target: "CoreRemoteImage", path: "../../Modules/Core/CoreRemoteImage")
            ]
        ),
        .target(
            name: "PokedexListingTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.matheusmartins.PokedexListingTests",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            sources: ["Tests/**"],
            dependencies: [
                .target(name: "PokedexListing")
            ]
        ),
        .target(
            name: "PokedexListingDemoApp",
            destinations: .iOS,
            product: .app,
            bundleId: "com.matheusmartins.PokedexListingDemoApp",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .extendingDefault(with: [
                "UILaunchScreen": [:]
            ]),
            sources: ["DemoApp/Sources/**"],
            resources: ["DemoApp/Resources/**"],
            dependencies: [
                .target(name: "PokedexListing")
            ]
        ),
        .target(
            name: "PokedexListingDemoAppTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.matheusmartins.PokedexListingDemoAppTests",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            sources: ["DemoApp/Tests/**"],
            dependencies: [
                .target(name: "PokedexListingDemoApp")
            ]
        )
    ]
)
