import ProjectDescription

let project = Project(
    name: "PokemonTeam",
    targets: [
        .target(
            name: "PokemonTeam",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.matheusmartins.PokemonTeam",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: [
                .project(target: "CoreNetworking", path: "../../Modules/Core/CoreNetworking"),
                .project(target: "CorePersistence", path: "../../Modules/Core/CorePersistence"),
                .project(target: "CoreDesignSystem", path: "../../Modules/Core/CoreDesignSystem")
            ]
        ),
        .target(
            name: "PokemonTeamTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.matheusmartins.PokemonTeamTests",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            sources: ["Tests/**"],
            dependencies: [
                .target(name: "PokemonTeam")
            ]
        ),
        .target(
            name: "PokemonTeamDemoApp",
            destinations: .iOS,
            product: .app,
            bundleId: "com.matheusmartins.PokemonTeamDemoApp",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            sources: ["DemoApp/Sources/**"],
            resources: ["DemoApp/Resources/**"],
            dependencies: [
                .target(name: "PokemonTeam")
            ]
        ),
        .target(
            name: "PokemonTeamDemoAppTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.matheusmartins.PokemonTeamDemoAppTests",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            sources: ["DemoApp/Tests/**"],
            dependencies: [
                .target(name: "PokemonTeamDemoApp")
            ]
        )
    ]
)
