import ProjectDescription

let project = Project(
    name: "ArtGallery",
    targets: [
        .target(
            name: "ArtGallery",
            destinations: .iOS,
            product: .app,
            bundleId: "io.tuist.ArtGallery",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                ]
            ),
            sources: ["ArtGallery/Sources/**"],
            resources: ["ArtGallery/Resources/**"],
            dependencies: [
                .external(name: "Alamofire"),
                .external(name: "Kingfisher")
            ]
        ),
        .target(
            name: "ArtGalleryTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.ArtGalleryTests",
            infoPlist: .default,
            sources: ["ArtGallery/Tests/**"],
            resources: [],
            dependencies: [
                .target(name: "ArtGallery")
            ]
        ),
    ]
)
