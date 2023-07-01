//
//  GroupCreateViewController.swift
//  Feature
//
//  Created by 홍성준 on 2023/07/01.
//

import UI
import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import ReactorKit

final class GroupCreateViewController: BaseViewController<GroupCreateReactor> {
    
    private var addButtonBottomConstraint: Constraint?
    
    private let navigationView = NavigationView(frame: .zero)
    private let groupTextField = CommonTextField(frame: .zero)
    private let addButton = ActionButton(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        groupTextField.becomeFirstResponder()
    }
    
    override func bind(reactor: GroupCreateReactor) {
        bindAction(reacotr: reactor)
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
        
        view.addSubview(groupTextField)
        groupTextField.snp.makeConstraints { make in
            make.top.equalTo(navigationView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        
        view.addSubview(addButton)
        addButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            addButtonBottomConstraint = make.bottom.equalTo(view.safeArea.bottom).offset(-10).constraint
            make.height.equalTo(50)
        }
    }
    
    override func setupAttributes() {
        view.backgroundColor = .monogray1
        
        navigationView.do {
            $0.configure(.init(
                type: .close,
                title: "그룹 추가",
                font: .bodySB
            ))
        }
        
        groupTextField.do {
            $0.layer.cornerRadius = 16
            $0.placeholder = "그룹을 입력해주세요"
            $0.textColor = .monoblack
            $0.backgroundColor = .white
            $0.font = .bodyR
        }
        
        addButton.do {
            $0.style = .normal
            $0.layer.cornerRadius = 16
            $0.setTitle("추가하기", for: .normal)
        }
    }
    
}

extension GroupCreateViewController {
    
    private func bindAction(reacotr: Reactor) {
        navigationView.rx.leftButtonTap
            .map { Reactor.Action.navigationLeftButtonTap }
            .bind(to: reacotr.action)
            .disposed(by: disposeBag)
        
        groupTextField.rx.text
            .compactMap { $0 }
            .map { Reactor.Action.groupTextDidChange($0) }
            .bind(to: reacotr.action)
            .disposed(by: disposeBag)
        
        addButton.rx.tap
            .map { Reactor.Action.addButtonDidTap }
            .bind(to: reacotr.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(reactor: Reactor) {
        reactor.state.map(\.isEnabled)
            .bind(to: addButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
    
    private func bindETC(reactor: Reactor) {
        NotificationCenter.default.rx.keyboardWillShow
            .compactMap { $0.keyboardSize }
            .bind(to: keyboardShowBinder)
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx.keyboardWillHide
            .bind(to: keyboardHideBinder)
            .disposed(by: disposeBag)
    }
    
    private var keyboardShowBinder: Binder<CGRect> {
        return Binder(self) { this, keyboardSize in
            this.addButtonBottomConstraint?.update(offset: -keyboardSize.height)
            UIView.animate(withDuration: 0.3) {
                this.view.layoutIfNeeded()
            }
        }
    }
    
    private var keyboardHideBinder: Binder<Notification> {
        return Binder(self) { this, _ in
            this.addButtonBottomConstraint?.update(offset: -10)
            UIView.animate(withDuration: 0.3) {
                this.view.layoutIfNeeded()
            }
        }
    }
    
    
}