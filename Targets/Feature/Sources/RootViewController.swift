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
        let appearance: UITabBarAppearance = self.tabBar.standardAppearance.then {
            $0.configureWithDefaultBackground()
            $0.shadowColor = .monogray2
            $0.backgroundColor = .white
            
            let normalFont: UIFont = UIFont.systemFont(ofSize: 11, weight: .thin)
            let selectedFont: UIFont = UIFont.systemFont(ofSize: 11, weight: .bold)
            $0.stackedLayoutAppearance.normal.titleTextAttributes = [.font: normalFont]
            $0.stackedLayoutAppearance.selected.titleTextAttributes = [.font: selectedFont]
            $0.stackedLayoutAppearance.normal.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -3)
            $0.stackedItemPositioning = .centered
        }
        self.tabBar.do {
            $0.barStyle = .default
            $0.standardAppearance = appearance
            if #available(iOS 15.0, *) {
                $0.scrollEdgeAppearance = $0.standardAppearance
            }
            $0.isTranslucent = false
            $0.tintColor = .blue1
            $0.unselectedItemTintColor = .monogray2
        }
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
