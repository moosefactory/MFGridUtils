// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

/*--------------------------------------------------------------------------*/
/*   /\/\/\__/\/\/\        MFGridUtils                                      */
/*   \/\/\/..\/\/\/                                                         */
/*        |  |             MooseFactory Grid Utilities                      */
/*        (oo)                                                              */
/* MooseFactory Software                                                    */
/*--------------------------------------------------------------------------*/

import PackageDescription

let package = Package(
    name: "MFGridUtils",
    platforms: [
        .macOS(.v11),
        .iOS(.v13)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "MFGridUtils",
            targets: ["MFGridUtils"]),
    ],
    dependencies: [
        .package(url: "https://github.com/moosefactory/MFFoundation.git", .upToNextMajor(from: "2.0.0"))
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "MFGridUtils",
            dependencies: ["MFFoundation"]),
        .testTarget(
            name: "MFGridUtilsTests",
            dependencies: ["MFGridUtils"]
        ),
    ]
)
