import ProjectDescription

let project = Project(
    name: "CoreDesignSystem",
    targets: [
        .target(
            name: "CoreDesignSystem",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.matheusmartins.CoreDesignSystem",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            sources: ["Sources/**"],
            resources: [],
            dependencies: [
                .project(target: "CoreRemoteImage", path: "../CoreRemoteImage")
            ]
        ),
        .target(
            name: "CoreDesignSystemTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.matheusmartins.CoreDesignSystemTests",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            sources: ["Tests/**"],
            dependencies: [
                .target(name: "CoreDesignSystem")
            ]
        )
    ]
)
