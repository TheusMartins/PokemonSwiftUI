import ProjectDescription

let project = Project(
    name: "CoreRemoteImage",
    targets: [
        .target(
            name: "CoreRemoteImage",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.matheusmartins.CoreRemoteImage",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            sources: ["Sources/**"],
            resources: [],
            dependencies: [
                .project(target: "CoreNetworking", path: "../CoreNetworking")
            ]
        ),
        .target(
            name: "CoreRemoteImageTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.matheusmartins.CoreRemoteImageTests",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            sources: ["Tests/**"],
            dependencies: [
                .target(name: "CoreRemoteImage")
            ]
        )
    ]
)
