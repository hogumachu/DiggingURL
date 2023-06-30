import ProjectDescription
import ProjectDescriptionHelpers
import MyPlugin

let setting = Settings.settings(configurations: [
    .debug(
        name: "Debug",
        xcconfig: .relativeToRoot("Targets/App/Configuration/Debug.xcconfig")
    ),
    .release(
        name: "Release",
        xcconfig: .relativeToRoot("Targets/App/Configuration/Release.xcconfig")
    )
])

func makeTargets() -> [Target] {
    let deploymentTarget = DeploymentTarget.iOS(targetVersion: "14.0", devices: [.iphone])
    let appTarget = Project.createAppTarget(
        name: "DiggingURL",
        deploymentTarget: deploymentTarget,
        dependencies: [
            .target(name: Module.feature.name),
            .target(name: Module.service.name)
        ]
    )
    let moduleTargets = Module.allCases.flatMap { $0.createTargets(deploymentTarget: deploymentTarget) }
    return [appTarget] + moduleTargets
}

let project = Project(
    name: "DiggingURL",
    packages: TargetDependency.XcodeSPM.allCases.map(\.package),
    settings: setting,
    targets: makeTargets()
)
