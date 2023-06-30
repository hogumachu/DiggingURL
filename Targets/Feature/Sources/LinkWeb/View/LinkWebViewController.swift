//
//  LinkWebViewController.swift
//  Feature
//
//  Created by 홍성준 on 2023/06/30.
//

import UI
import UIKit
import WebKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import ReactorKit
import RxDataSources

final class LinkWebViewController: BaseViewController<LinkWebReactor> {
    
    private var webNavigationViewTopConstraint: Constraint?
    
    private let navigationView = NavigationView(frame: .zero)
    private let webNavigationView = LinkWebNavigationView(frame: .zero)
    private let webView = WKWebView()
    
    override func bind(reactor: LinkWebReactor) {
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
        
        view.insertSubview(webNavigationView, belowSubview: navigationView)
        webNavigationView.snp.makeConstraints { make in
            webNavigationViewTopConstraint = make.top.equalTo(navigationView.snp.bottom).constraint
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(40)
        }
        
        view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.top.equalTo(webNavigationView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    override func setupAttributes() {
        view.backgroundColor = .monogray1
        
        navigationView.do {
            $0.configure(.init(
                type: .close,
                title: reactor?.initialState.title,
                font: .bodySB
            ))
            $0.backgroundColor = .monogray1
        }
        
        webNavigationView.do {
            $0.backgroundColor = .monogray1
        }
        
        webView.do {
            $0.backgroundColor = .monogray1
        }
    }
    
}

extension LinkWebViewController {
    
    private func bindAction(reactor: Reactor) {
        navigationView.rx.leftButtonTap
            .map { Reactor.Action.navigationLeftButtonTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(reactor: Reactor) {
        reactor.state.map(\.title)
            .bind(to: navigationView.rx.centerTitle)
            .disposed(by: disposeBag)
        
        reactor.state.map(\.url)
            .bind(to: urlBinder)
            .disposed(by: disposeBag)
    }
    
    private func bindETC(reactor: Reactor) {
        webView.scrollView.rx.willEndDragging
            .bind(to: scrollBinder)
            .disposed(by: disposeBag)
        
        webNavigationView.rx.backButtonTap
            .withUnretained(self.webView)
            .subscribe(onNext: { this, _ in this.goBack() })
            .disposed(by: disposeBag)
        
        webNavigationView.rx.forwardButtonTap
            .withUnretained(self.webView)
            .subscribe(onNext: { this, _ in this.goForward() })
            .disposed(by: disposeBag)
        
        webNavigationView.rx.refreshButtonTap
            .withUnretained(self.webView)
            .subscribe(onNext: { this, _ in this.reload() })
            .disposed(by: disposeBag)
    }
    
    private var urlBinder: Binder<String> {
        return Binder(self.webView) { this, url in
            guard let url = URL(string: url) else {
                return
            }
            let request = URLRequest(url: url)
            this.load(request)
        }
    }
    
    private var scrollBinder: Binder<(velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>)> {
        return Binder(self) { this, element in
            element.velocity.y > 0 ? this.hideWebNavigationView() : this.showWebNavigationView()
        }
    }
    
    private func hideWebNavigationView() {
        self.webNavigationViewTopConstraint?.update(offset: -39)
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
    
    private func showWebNavigationView() {
        self.webNavigationViewTopConstraint?.update(offset: 0)
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
    
}
