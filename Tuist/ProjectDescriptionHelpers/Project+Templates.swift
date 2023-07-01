import ProjectDescription

/// Project helpers are functions that simplify the way you define your project.
/// Share code to create targets, settings, dependencies,
/// Create your own conventions, e.g: a func that makes sure all shared targets are "static frameworks"
/// See https://docs.tuist.io/guides/helpers/

extension Project {
    /// Helper function to create the Project for this ExampleApp
    public static func app(name: String, platform: Platform, additionalTargets: [String]) -> Project {
        var targets = makeAppTargets(name: name,
                                     platform: platform,
                                     dependencies: additionalTargets.map { TargetDependency.target(name: $0) })
        targets += additionalTargets.flatMap({ makeFrameworkTargets(name: $0, platform: platform) })
        return Project(name: name,
                       organizationName: "tuist.io",
                       targets: targets)
    }
    
    public static func createFeatureTargets(
        name: String,
        deploymentTarget: DeploymentTarget,
        dependencies: [TargetDependency]
    ) -> [Target] {
        return [
            Target(
                name: name,
                platform: .iOS,
                product: .framework,
                bundleId: "io.tuist.\(name)",
                deploymentTarget: deploymentTarget,
                infoPlist: .default,
                sources: ["Targets/\(name)/Sources/**"],
                resources: [],
                dependencies: dependencies
            ),
            Target(
                name: "\(name)Tests",
                platform: .iOS,
                product: .unitTests,
                bundleId: "io.tuist.\(name)Tests",
                deploymentTarget: deploymentTarget,
                infoPlist: .default,
                sources: ["Targets/\(name)/Tests/**"],
                resources: [],
                dependencies: [.target(name: name)]
            )
        ]
    }
    
    public static func createAppTarget(
        name: String,
        deploymentTarget: DeploymentTarget,
        dependencies: [TargetDependency]
    ) -> Target {
        let plist: [String: InfoPlist.Value] = [
            "UIMainStoryboardFile": "",
            "CFBundleDisplayName": "$(PRODUCT_NAME)",
            "UILaunchStoryboardName": "LaunchScreen",
            "UIUserInterfaceStyle": "Light",
            "UISupportedInterfaceOrientations": ["UIInterfaceOrientationPortrait"],
            "UIApplicationSceneManifest": [
              "UIApplicationSupportsMultipleScenes": false,
              "UISceneConfigurations": [
                "UIWindowSceneSessionRoleApplication": [
                  [
                    "UISceneConfigurationName": "Default Configuration",
                    "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate"
                  ],
                ]
              ]
            ],
        ]
        
        return Target(
            name: name,
            platform: .iOS,
            product: .app,
            bundleId: "io.tuist.\(name)",
            deploymentTarget: deploymentTarget,
            infoPlist: .extendingDefault(with: plist),
            sources: ["Targets/App/Sources/**"],
            resources: ["Targets/App/Resources/**"],
            dependencies: dependencies
        )
    }
    

    // MARK: - Private

    /// Helper function to create a framework target and an associated unit test target
    private static func makeFrameworkTargets(name: String, platform: Platform) -> [Target] {
        let sources = Target(name: name,
                platform: platform,
                product: .framework,
                bundleId: "io.tuist.\(name)",
                infoPlist: .default,
                sources: ["Targets/\(name)/Sources/**"],
                resources: [],
                dependencies: [])
        let tests = Target(name: "\(name)Tests",
                platform: platform,
                product: .unitTests,
                bundleId: "io.tuist.\(name)Tests",
                infoPlist: .default,
                sources: ["Targets/\(name)/Tests/**"],
                resources: [],
                dependencies: [.target(name: name)])
        return [sources, tests]
    }

    /// Helper function to create the application target and the unit test target.
    private static func makeAppTargets(name: String, platform: Platform, dependencies: [TargetDependency]) -> [Target] {
        let platform: Platform = platform
        let infoPlist: [String: InfoPlist.Value] = [
            "CFBundleShortVersionString": "1.0",
            "CFBundleVersion": "1",
            "UIMainStoryboardFile": "",
            "UILaunchStoryboardName": "LaunchScreen"
            ]

        let mainTarget = Target(
            name: name,
            platform: platform,
            product: .app,
            bundleId: "io.tuist.\(name)",
            infoPlist: .extendingDefault(with: infoPlist),
            sources: ["Targets/\(name)/Sources/**"],
            resources: ["Targets/\(name)/Resources/**"],
            dependencies: dependencies
        )

        let testTarget = Target(
            name: "\(name)Tests",
            platform: platform,
            product: .unitTests,
            bundleId: "io.tuist.\(name)Tests",
            infoPlist: .default,
            sources: ["Targets/\(name)/Tests/**"],
            dependencies: [
                .target(name: "\(name)")
        ])
        return [mainTarget, testTarget]
    }
}

// MARK: - Module

public enum Module: CaseIterable {
    case core
    case domain
    case service
    case ui
    case feature
    
    public var name: String {
        switch self {
        case .core: return "Core"
        case .domain: return "Domain"
        case .service: return "Service"
        case .ui: return "UI"
        case .feature: return "Feature"
        }
    }
}

public extension Module {
    
    var dependencies: [TargetDependency] {
        switch self {
        case .core:
            return [
                .SPM.rxSwift.object,
                .SPM.rxRelay.object,
                .SPM.swinject.object
            ]
            
        case .domain:
            return [
                .target(name: Module.core.name)
            ]
            
        case .service:
            return [
                .target(name: Module.domain.name),
                .XcodeSPM.realmSwift.object
            ]
            
        case .ui:
            return [
                .target(name: Module.domain.name),
                .SPM.rxCocoa.object,
                .SPM.lottie.object,
                .SPM.kingfisher.object
            ]
            
        case .feature:
            return [
                .target(name: Module.ui.name),
                .target(name: Module.service.name),
                .SPM.reactorKit.object,
                .SPM.rxDataSources.object,
                .SPM.snapKit.object,
                .SPM.then.object
            ]
        }
    }
    
    func createTargets(deploymentTarget: DeploymentTarget) -> [Target] {
        return Project.createFeatureTargets(
            name: name,
            deploymentTarget: deploymentTarget,
            dependencies: dependencies
        )
    }
    
}

// MARK: - TargetDependency

public extension TargetDependency {
    
    enum SPM: CaseIterable {
        case rxSwift
        case rxCocoa
        case rxRelay
        case reactorKit
        case rxDataSources
        case snapKit
        case then
        case swinject
        case lottie
        case kingfisher
        
        public var object: TargetDependency {
            switch self {
            case .rxSwift: return TargetDependency.external(name: "RxSwift")
            case .rxCocoa: return TargetDependency.external(name: "RxCocoa")
            case .rxRelay: return TargetDependency.external(name: "RxRelay")
            case .reactorKit: return TargetDependency.external(name: "ReactorKit")
            case .rxDataSources: return TargetDependency.external(name: "RxDataSources")
            case .snapKit: return TargetDependency.external(name: "SnapKit")
            case .then: return TargetDependency.external(name: "Then")
            case .swinject: return TargetDependency.external(name: "Swinject")
            case .lottie: return TargetDependency.external(name: "Lottie")
            case .kingfisher: return TargetDependency.external(name: "Kingfisher")
            }
        }
        
        public var package: Package? {
            switch self {
            case .rxSwift:
                return .remote(url: "https://github.com/ReactiveX/RxSwift.git", requirement: .upToNextMinor(from: "6.5.0"))
                
            case .rxCocoa:
                return nil
                
            case .rxRelay:
                return nil
                
            case .reactorKit:
                return .remote(url: "https://github.com/ReactorKit/ReactorKit.git", requirement: .upToNextMinor(from: "3.2.0"))
                
            case .rxDataSources:
                return .remote(url: "https://github.com/RxSwiftCommunity/RxDataSources.git", requirement: .upToNextMajor(from: "5.0.0"))
                
            case .snapKit:
                return .remote(url: "https://github.com/SnapKit/SnapKit.git", requirement: .upToNextMinor(from: "5.0.0"))
                
            case .then:
                return .remote(url: "https://github.com/devxoul/Then", requirement: .upToNextMinor(from: "2.7.0"))
                
            case .swinject:
                return .remote(url: "https://github.com/Swinject/Swinject.git", requirement: .upToNextMajor(from: "2.8.0"))
                
            case .lottie:
                return .remote(url: "https://github.com/airbnb/lottie-ios.git", requirement: .upToNextMajor(from: "4.2.0"))
                
            case .kingfisher:
                return .remote(url: "https://github.com/onevcat/Kingfisher.git", requirement: .upToNextMajor(from: "7.0.0"))
            }
        }
    }
    
    enum XcodeSPM: CaseIterable {
        case realmSwift
        
        public var object: TargetDependency {
            switch self {
            case .realmSwift: return TargetDependency.package(product: "RealmSwift")
            }
        }
        
        public var package: Package {
            switch self {
            case .realmSwift: return .remote(url: "https://github.com/realm/realm-swift.git", requirement: .upToNextMajor(from: "10.39.1"))
            }
        }
    }
    
}
