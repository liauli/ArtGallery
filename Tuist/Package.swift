// swift-tools-version: 6.0
import PackageDescription

#if TUIST
    import ProjectDescription

    let packageSettings = PackageSettings(
        productTypes: [
            "Alamofire": .framework,
            "Kingfisher": .framework
        ]
    )

#endif

let package = Package(
    name: "ArtGallery",
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire", from: "5.10.0"),
        .package(url: "https://github.com/onevcat/Kingfisher.git", from: "8.0.0")
    ]
)
