//
//  SceneFactory.swift
//  Feature
//
//  Created by 홍성준 on 2023/06/30.
//

import Core
import UIKit
import Then

public enum Scene {
    case root
    case home
}

public protocol SceneFactory {
    func create(scene: Scene) -> UIViewController
}

public final class SceneFactoryImp: SceneFactory {
    
    private let injector: DependencyInjector
    
    public init(injector: some DependencyInjector) {
        self.injector = injector
    }
    
    public func create(scene: Scene) -> UIViewController {
        let coordinator = injector.resovle(AppCoordinator.self)
        
        switch scene {
        case .root:
            let rootViewController = RootViewController(coordinator: coordinator)
            let homeViewController: UINavigationController = {
                let homeVC = create(scene: .home)
                homeVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "grid"), selectedImage: nil)
                homeVC.tabBarItem.title = "홈"
                return UINavigationController(rootViewController: homeVC).then {
                    $0.setNavigationBarHidden(true, animated: false)
                    $0.interactivePopGestureRecognizer?.delegate = nil
                }
            }()
            rootViewController.setViewControllers(
                [
                    // TODO: - Setup ViewControllers
                    homeViewController
                ],
                animated: false
            )
            
            return rootViewController
            
        case .home:
            let dependency = HomeReactor.Dependency()
            let reactor = HomeReactor(dependency: dependency)
            let viewController = HomeViewController(reactor: reactor)
            return viewController
        }
    }
}
