import ProjectDescription

let project = Project(
    name: "CorePersistence",
    targets: [
        .target(
            name: "CorePersistence",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.matheusmartins.CorePersistence",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            sources: ["Sources/**"],
            resources: []
        ),
        .target(
            name: "CorePersistenceTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.matheusmartins.CorePersistenceTests",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            sources: ["Tests/**"],
            dependencies: [
                .target(name: "CorePersistence")
            ]
        )
    ]
)
