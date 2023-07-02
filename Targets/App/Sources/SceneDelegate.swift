import Core
import Domain
import Service
import Feature
import UIKit
import Swinject

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    private var coordinator: AppCoordinator?
    private let injector: DependencyInjector = DependencyInjectorImpl(container: Container())
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = scene as? UIWindowScene else { return }
        let window = UIWindow(windowScene: scene)
        self.window = window
        window.makeKeyAndVisible()
        setupDependencies()
        coordinator?.start(root: .root)
    }

    func sceneDidDisconnect(_ scene: UIScene) {}
    func sceneDidBecomeActive(_ scene: UIScene) {}
    func sceneWillResignActive(_ scene: UIScene) {}
    func sceneWillEnterForeground(_ scene: UIScene) {}
    func sceneDidEnterBackground(_ scene: UIScene) {}
    
}

extension SceneDelegate {
    
    private func setupDependencies() {
        let factory = SceneFactoryImp(injector: injector)
        let coordinator = AppCoordinatorImp(factory: factory)
        self.coordinator = coordinator
        injector.assemble([DomainAssembly(), ServiceAssembly()])
        injector.register(AppCoordinator.self, coordinator)
    }
    
}
