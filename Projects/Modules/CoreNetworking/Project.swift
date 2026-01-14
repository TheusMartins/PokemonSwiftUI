import ProjectDescription

let project = Project(
    name: "CoreNetworking",
    targets: [
        .target(
            name: "CoreNetworking",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.matheusmartins.CoreNetworking",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            sources: ["Sources/**"],
            resources: []
        ),
        .target(
            name: "CoreNetworkingTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.matheusmartins.CoreNetworkingTests",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            sources: ["Tests/**"],
            dependencies: [
                .target(name: "CoreNetworking")
            ]
        )
    ]
)
