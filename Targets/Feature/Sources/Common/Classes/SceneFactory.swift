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
        switch scene {
        case .root:
            // TODO: - Change to RootViewController
            return UIViewController()
        }
    }
}
