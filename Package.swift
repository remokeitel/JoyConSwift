// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "JoyConSwift",
    platforms: [
        .macOS(.v10_14)
    ],
    products: [
        .library(name: "JoyConSwift", targets: ["JoyConSwift"]),
    ],
    targets: [
        .target(
            name: "JoyConSwift",
            path: "Source",
            exclude: ["Info.plist", "JoyConSwift.h"]
        ),
    ]
)
