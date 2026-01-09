import ProjectDescription

let project = Project(
    name: "PokedexShowcase",
    targets: [
        .target(
            name: "PokedexShowcase",
            destinations: .iOS,
            product: .app,
            bundleId: "com.matheusmartins.pokedexshowcase",
            infoPlist: .extendingDefault(with: [
                "UILaunchScreen": [:]
            ]),
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: [
                .project(target: "PokedexListing", path: "../Features/PokedexListing"),
                .project(target: "PokemonTeam", path: "../Features/PokemonTeam")
            ]
        ),
        .target(
            name: "PokedexShowcaseTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.matheusmartins.pokedexshowcase.tests",
            infoPlist: .default,
            sources: ["Tests/**"],
            dependencies: [
                .target(name: "PokedexShowcase")
            ]
        )
    ]
)
