//
//  SceneFactory.swift
//  Feature
//
//  Created by 홍성준 on 2023/06/30.
//

import Core
import Domain
import Service
import UIKit
import Then

public enum Scene {
    case root
    case home
    case homeGroupDetail(Group)
    case linkWeb(title: String, url: String)
    case groupCreate
    case linkCreate(groupID: Date)
    case linkEdit(groupID: Date, link: Link)
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
        let groupUseCase = injector.resovle(GroupUseCase.self)
        let linkUseCase = injector.resovle(LinkUseCase.self)
        let notificationManager = injector.resovle(NotificationManager.self)
        
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
            let dependency = HomeReactor.Dependency(
                coordinator: coordinator,
                groupUseCase: groupUseCase,
                notificationManager: notificationManager
                
            )
            let reactor = HomeReactor(dependency: dependency)
            let viewController = HomeViewController(reactor: reactor)
            return viewController
            
        case .homeGroupDetail(let group):
            let dependency = HomeGroupDetailReactor.Dependency(
                coordinator: coordinator,
                group: group,
                linkUseCase: linkUseCase,
                notificationManager: notificationManager
            )
            let reactor = HomeGroupDetailReactor(dependency: dependency)
            let viewController = HomeGroupDetailViewController(reactor: reactor)
            return viewController
            
        case .linkWeb(let title, let url):
            let dependency = LinkWebReactor.Dependency(
                coordinator: coordinator,
                title: title,
                url: url
            )
            let reactor = LinkWebReactor(dependency: dependency)
            let viewController = LinkWebViewController(reactor: reactor)
            return viewController
            
        case .groupCreate:
            let dependency = GroupCreateReactor.Dependency(
                coordinator: coordinator,
                groupUseCase: groupUseCase,
                notifictionManger: notificationManager
            )
            let reactor = GroupCreateReactor(dependency: dependency)
            let viewController = GroupCreateViewController(reactor: reactor)
            return viewController
            
        case .linkCreate(let groupID):
            let dependency = LinkCreateReactor.Dependency(
                link: nil,
                groupID: groupID,
                coordinator: coordinator,
                linkUseCase: linkUseCase,
                notificationManager: notificationManager
            )
            let reactor = LinkCreateReactor(dependency: dependency)
            let viewController = LinkCreateViewController(reactor: reactor)
            return viewController
                
        case .linkEdit(let groupID, let link):
            let dependency = LinkCreateReactor.Dependency(
                link: link,
                groupID: groupID,
                coordinator: coordinator,
                linkUseCase: linkUseCase,
                notificationManager: notificationManager
            )
            let reactor = LinkCreateReactor(dependency: dependency)
            let viewController = LinkCreateViewController(reactor: reactor)
            return viewController
        }
    }
}
