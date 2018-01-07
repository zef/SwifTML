// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "SwifTML",
    targets: [
        .target(
            name: "SwifTML",
            path: "Sources"
            // exclude: ["GenerateTags.swift"]
        )
    ]
)

