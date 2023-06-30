//
//  AppCoordinator.swift
//  Feature
//
//  Created by 홍성준 on 2023/06/30.
//

import Core
import UIKit

public enum TransitionStyle {
    case modal
    case push
}

public enum CloseStyle {
    case pop
    case dismiss
}

public protocol AppCoordinator {
    func start(root: Scene)
    func transition(to scene: Scene, using style: TransitionStyle, animated: Bool, completion: (() -> Void)?)
    func close(using style: CloseStyle, animated: Bool, completion: (() -> Void)?)
}

public final class AppCoordinatorImp: AppCoordinator {
    
    private var currentNavigationController: UINavigationController?
    private let factory: SceneFactory
    
    public init(factory: some SceneFactory) {
        self.factory = factory
    }
    
    public func start(root: Scene) {
        // TODO: - Create RootViewController
    }
    
    public func transition(to scene: Scene, using style: TransitionStyle, animated: Bool, completion: (() -> Void)?) {
        
    }
    
    public func close(using style: CloseStyle, animated: Bool, completion: (() -> Void)?) {
        
    }
    
}
