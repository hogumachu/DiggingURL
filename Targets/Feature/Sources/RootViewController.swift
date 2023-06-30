//
//  RootViewController.swift
//  Feature
//
//  Created by 홍성준 on 2023/06/30.
//

import UIKit
import RxSwift

final class RootViewController: UITabBarController {
    
    private var coordinator: AppCoordinator
    private var currentIndex: Int?
    private let disposeBag = DisposeBag()
    
    init(coordinator: AppCoordinator) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        setupTabBar()
    }
    
    private func setupTabBar() {
        // TODO: - Setup Tab Bar
    }
    
}

extension RootViewController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        currentIndex = tabBarController.selectedIndex
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard let index = tabBarController.viewControllers?.firstIndex(of: viewController) else {
            return true
        }
        if currentIndex == index {
            if let navigationController = viewController as? UINavigationController {
                (navigationController.topViewController as? TopScrollable)?.scrollToTop()
            } else {
                (viewController as? TopScrollable)?.scrollToTop()
            }
        }
        return true
    }
    
}

extension RootViewController: Refreshable {
    
    func refresh() {
        guard let index = currentIndex,
              let viewController = viewControllers?[safe: index]
        else {
            return
        }
        
        if currentIndex == index {
            if let navigationController = viewController as? UINavigationController {
                (navigationController.topViewController as? TopScrollable)?.scrollToTop()
            } else {
                (viewController as? TopScrollable)?.scrollToTop()
            }
        }
    }
    
}
