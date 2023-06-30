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
            rootViewController.setViewControllers(
                [
                    // TODO: - Setup ViewControllers
                ],
                animated: false
            )
            
            return rootViewController
        }
    }
}
