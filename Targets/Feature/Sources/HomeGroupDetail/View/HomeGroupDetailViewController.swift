//
//  HomeGroupDetailViewController.swift
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

final class HomeGroupDetailViewController: BaseViewController<HomeGroupDetailReactor> {
    
    typealias Section = RxTableViewSectionedReloadDataSource<HomeGroupDetailSection>
    
    private let navigationView = NavigationView(frame: .zero)
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private let addButton = ActionButton(frame: .zero)
    private lazy var dataSource = Section  { section, tableView, indexPath, item in
        guard let cell = tableView.dequeueCell(HomeGroupDetailTableViewCell.self, for: indexPath) else {
            return UITableViewCell()
        }
        cell.configure(item.cellModel)
        return cell
    }
    
    override func bind(reactor: HomeGroupDetailReactor) {
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
        
        view.addSubview(addButton)
        addButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeArea.bottom).offset(-10)
            make.height.equalTo(50)
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(navigationView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(addButton.snp.top)
        }
    }
    
    override func setupAttributes() {
        view.backgroundColor = .monogray1
        
        navigationView.do {
            $0.configure(.init(
                type: .back,
                title: reactor?.initialState.title,
                font: .bodySB
            ))
        }
        
        tableView.do {
            $0.backgroundColor = .monogray1
            $0.showsVerticalScrollIndicator = false
            $0.separatorStyle = .none
            $0.register(HomeGroupDetailTableViewCell.self)
        }
        
        addButton.do {
            $0.style = .normal
            $0.setTitle("링크 추가하기", for: .normal)
            $0.layer.cornerRadius = 16
        }
    }
    
}

// MARK: - Bind

extension HomeGroupDetailViewController {
    
    private func bindAction(reactor: Reactor) {
        rx.viewDidLoad
            .map { Reactor.Action.refresh }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        navigationView.rx.leftButtonTap
            .map { Reactor.Action.navigationLeftButtonTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected(dataSource: dataSource)
            .map { Reactor.Action.itemSelected($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(reactor: Reactor) {
        reactor.state.map(\.title)
            .bind(to: navigationView.rx.centerTitle)
            .disposed(by: disposeBag)
        
        reactor.state.map(\.sections)
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    private func bindETC(reactor: Reactor) {
        tableView.rx.itemSelected
            .asSignal()
            .emit(to: itemSelectedBinder)
            .disposed(by: disposeBag)
    }
    
    private var itemSelectedBinder: Binder<IndexPath> {
        return Binder(self.tableView) { tableView, indexPath in
            guard let cell = tableView.cellForRow(at: indexPath) as? HomeGroupDetailTableViewCell else { return }
            tableView.performBatchUpdates {
                cell.selectAnimate()
            }
        }
    }
    
}

extension HomeGroupDetailViewController: UITableViewDelegate {}
