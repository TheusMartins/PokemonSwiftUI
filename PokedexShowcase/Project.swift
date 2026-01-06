import ProjectDescription

let project = Project(
    name: "PokedexShowcase",
    targets: [
        .target(
            name: "PokedexShowcase",
            destinations: .iOS,
            product: .app,
            bundleId: "dev.tuist.PokedexShowcase",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                ]
            ),
            buildableFolders: [
                "PokedexShowcase/Sources",
                "PokedexShowcase/Resources",
            ],
            dependencies: []
        ),
        .target(
            name: "PokedexShowcaseTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "dev.tuist.PokedexShowcaseTests",
            infoPlist: .default,
            buildableFolders: [
                "PokedexShowcase/Tests"
            ],
            dependencies: [.target(name: "PokedexShowcase")]
        ),
    ]
)
