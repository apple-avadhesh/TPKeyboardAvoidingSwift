// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "TPKeyboardAvoiding",
    platforms: [.iOS(.v10)],
    products: [
        .library(name: "TPKeyboardAvoiding",
                 targets: ["TPKeyboardAvoiding"])
    ],
    targets: [
        .target(
            name: "TPKeyboardAvoiding",
            path: "TPKeyboardAvoidingSwift"
        )
    ],
    swiftLanguageVersions: [.v5]
)
