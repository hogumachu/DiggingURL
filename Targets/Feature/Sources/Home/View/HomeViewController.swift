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
import ReactorKit
import RxDataSources

final class HomeViewController: BaseViewController<HomeReactor> {
    
    typealias Section = RxTableViewSectionedReloadDataSource<HomeSection>
    
    private let navigationView = NavigationView(frame: .zero)
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private lazy var dataSource = Section { section, tableView, indexPath, item in
        switch item {
        case .title(let title):
            guard let cell = tableView.dequeueCell(TextOnlyTableViewCell.self, for: indexPath) else {
                return UITableViewCell()
            }
            cell.configure(
                text: title,
                inset: UIEdgeInsets(top: 0, left: 20, bottom: 20, right: 20)
            )
            return cell
            
        case .group(let model):
            guard let cell = tableView.dequeueCell(HomeGroupTableViewCell.self, for: indexPath) else {
                return UITableViewCell()
            }
            cell.configure(model)
            return cell
        }
    }
    
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
        
        tableView.do {
            $0.backgroundColor = .monogray1
            $0.showsVerticalScrollIndicator = false
            $0.separatorStyle = .none
            $0.register(TextOnlyTableViewCell.self)
            $0.register(HomeGroupTableViewCell.self)
        }
    }
    
}

// MARK: - Bind

extension HomeViewController {
    
    private func bindAction(reactor: Reactor) {
        rx.viewDidLoad
            .map { Reactor.Action.refresh }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected(dataSource: dataSource)
            .map(Reactor.Action.itemSelected)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(reactor: Reactor) {
        reactor.state.map(\.sections)
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    private func bindETC(reactor: Reactor) {
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        tableView.rx.didScroll
            .asSignal()
            .emit(to: scrollBinder)
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .asSignal()
            .emit(to: itemSelectedBinder)
            .disposed(by: disposeBag)
    }
    
    private var scrollBinder: Binder<Void> {
        return Binder(self) { this, _ in
            let offset = this.tableView.contentOffset
            offset.y >= 10 ? this.navigationView.showSeparator() : this.navigationView.hideSeparator()
        }
    }
    
    private var itemSelectedBinder: Binder<IndexPath> {
        return Binder(self.tableView) { tableView, indexPath in
            guard let cell = tableView.cellForRow(at: indexPath) as? HomeGroupTableViewCell else { return }
            tableView.performBatchUpdates {
                cell.selectAnimate()
            }
        }
    }
    
}

extension HomeViewController: UITableViewDelegate {}
