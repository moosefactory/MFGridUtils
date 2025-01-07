// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

/*--------------------------------------------------------------------------*/
/*   /\/\/\__/\/\/\        MooseFactory Foundation - Swift - v2.0           */
/*   \/\/\/..\/\/\/                                                         */
/*        |  |             (c)2007-2025 Tristan Leblanc                     */
/*        (oo)                                                              */
/* MooseFactory Software                                                    */
/*--------------------------------------------------------------------------*/

import PackageDescription

let package = Package(
    name: "MFFoundation",
    platforms: [
        .macOS(.v11),
        .iOS(.v13)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "MFFoundation",
            targets: ["MFFoundation"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "MFFoundation"),
        .testTarget(
            name: "MFFoundationTests",
            dependencies: ["MFFoundation"]
        ),
    ]
)
