//
//  HomeViewController.swift
//  Feature
//
//  Created by 홍성준 on 2023/06/30.
//

import UI
import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

final class HomeViewController: BaseViewController<HomeReactor> {
    
    private let navigationView = NavigationView(frame: .zero)
    private let tableView = UITableView(frame: .zero, style: .grouped)
    
    override func bind(reactor: HomeReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
        bindETC(reactor: reactor)
    }
    
    override func setupLayout() {
        view.addSubview(navigationView)
        navigationView.snp.makeConstraints { make in
            make.top.equalTo(view.safeArea.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(48)
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(navigationView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    override func setupAttributes() {
        view.backgroundColor = .monogray1
        
        navigationView.do {
            $0.configure(.init(
                type: .titleWithRightButtons([.setting]),
                title: "홈",
                font: .headerB
            ))
        }
        
        // TODO: - Setup TableView
        tableView.do {
            $0.backgroundColor = .monogray1
            $0.showsVerticalScrollIndicator = false
            $0.separatorStyle = .none
        }
    }
    
}

// MARK: - Bind

extension HomeViewController {
    
    private func bindAction(reactor: Reactor) {
        
    }
    
    private func bindState(reactor: Reactor) {
        
    }
    
    private func bindETC(reactor: Reactor) {
        
    }
    
}
