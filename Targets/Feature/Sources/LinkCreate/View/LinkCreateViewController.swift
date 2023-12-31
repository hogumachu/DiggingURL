//
//  LinkCreateViewController.swift
//  Feature
//
//  Created by 홍성준 on 2023/07/02.
//

import UI
import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import ReactorKit

final class LinkCreateViewController: BaseViewController<LinkCreateReactor> {
    
    private var buttonStackViewBottomConstraint: Constraint?
    
    private let navigationView = NavigationView(frame: .zero)
    private let scrollView = UIScrollView(frame: .zero)
    private let contentStackView = UIStackView(frame: .zero)
    private let nameLabel = UILabel(frame: .zero)
    private let nameTextField = CommonTextField(frame: .zero)
    private let urlLabel = UILabel(frame: .zero)
    private let urlTextField = CommonTextField(frame: .zero)
    private let descLabel = UILabel(frame: .zero)
    private let descTextField = CommonTextField(frame: .zero)
    private let buttonStackView = UIStackView(frame: .zero)
    private let addButton = ActionButton(frame: .zero)
    private let removeButton = ActionButton(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.becomeFirstResponder()
    }
    
    override func bind(reactor: LinkCreateReactor) {
        bindState(reactor: reactor)
        bindAction(reactor: reactor)
        bindETC(reactor: reactor)
    }
    
    override func setupLayout() {
        view.addSubview(navigationView)
        navigationView.snp.makeConstraints { make in
            make.top.equalTo(view.safeArea.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(48)
        }
        
        view.addSubview(buttonStackView)
        buttonStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            buttonStackViewBottomConstraint = make.bottom.equalTo(view.safeArea.bottom).offset(-10).constraint
            make.height.equalTo(50)
        }
        
        buttonStackView.addArrangedSubview(removeButton)
        buttonStackView.addArrangedSubview(addButton)
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(navigationView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(addButton.snp.top)
        }
        
        scrollView.addSubview(contentStackView)
        contentStackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalTo(view).inset(20)
        }
        
        contentStackView.addArrangedSubview(nameLabel)
        contentStackView.addArrangedSubview(nameTextField)
        nameTextField.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
        
        contentStackView.addArrangedSubview(urlLabel)
        contentStackView.addArrangedSubview(urlTextField)
        urlTextField.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
        
        contentStackView.addArrangedSubview(descLabel)
        contentStackView.addArrangedSubview(descTextField)
        descTextField.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
    }
    
    override func setupAttributes() {
        view.backgroundColor = .monogray1
        
        navigationView.do {
            $0.configure(.init(
                type: .close,
                title: "링크 추가",
                font: .bodySB
            ))
        }
        
        scrollView.do {
            $0.backgroundColor = .monogray1
            $0.showsVerticalScrollIndicator = false
            $0.contentInset = UIEdgeInsets(top: 30, left: 0, bottom: 0, right: 0)
        }
        
        contentStackView.do {
            $0.axis = .vertical
            $0.distribution = .equalSpacing
            $0.alignment = .fill
            $0.spacing = 20
        }
        
        nameLabel.do {
            $0.text = "제목"
            $0.textColor = .monoblack
            $0.font = .bodySB
        }
        
        nameTextField.do {
            $0.layer.cornerRadius = 16
            $0.placeholder = "제목을 입력해주세요"
            $0.textColor = .monoblack
            $0.backgroundColor = .white
            $0.font = .bodyR
            $0.text = reactor?.initialState.name
        }
        
        urlLabel.do {
            $0.text = "주소"
            $0.textColor = .monoblack
            $0.font = .bodySB
        }
        
        urlTextField.do {
            $0.layer.cornerRadius = 16
            $0.placeholder = "주소를 입력해주세요"
            $0.textColor = .monoblack
            $0.backgroundColor = .white
            $0.font = .bodyR
            $0.text = reactor?.initialState.url
        }
        
        descLabel.do {
            $0.text = "설명 (선택)"
            $0.textColor = .monoblack
            $0.font = .bodySB
        }
        
        descTextField.do {
            $0.layer.cornerRadius = 16
            $0.placeholder = "설명을 입력해주세요"
            $0.textColor = .monoblack
            $0.backgroundColor = .white
            $0.font = .bodyR
            $0.text = reactor?.initialState.description
        }
        
        buttonStackView.do {
            $0.axis = .horizontal
            $0.spacing = 10
            $0.alignment = .fill
            $0.distribution = .fillEqually
        }
        
        addButton.do {
            $0.style = .normal
            $0.layer.cornerRadius = 16
            $0.setTitle("추가하기", for: .normal)
        }
        
        removeButton.do {
            $0.style = .secondary
            $0.layer.cornerRadius = 16
            $0.setTitle("제거하기", for: .normal)
        }
    }
    
}

extension LinkCreateViewController {
    
    private func bindAction(reactor: Reactor) {
        nameTextField.rx.text
            .compactMap { $0 }
            .map { Reactor.Action.nameDidUpdate($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        urlTextField.rx.text
            .compactMap { $0 }
            .map { Reactor.Action.urlDidUpdate($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        descTextField.rx.text
            .compactMap { $0 }
            .map { Reactor.Action.descriptionDidUpdate($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        addButton.rx.tap
            .map { Reactor.Action.addButtonTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        removeButton.rx.tap
            .map { Reactor.Action.removeButtonTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        navigationView.rx.leftButtonTap
            .map { Reactor.Action.navigationLeftButtonTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        descTextField.rx.returnKeyDidTap
            .filter { self.addButton.isEnabled }
            .map { Reactor.Action.addButtonTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(reactor: Reactor) {
        reactor.state.map(\.isEnabled)
            .bind(to: addButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        reactor.state.map(\.isCreate)
            .map { $0 ? "추가하기" : "변경하기" }
            .bind(to: addButton.rx.title())
            .disposed(by: disposeBag)
        
        reactor.state.map(\.isCreate)
            .map { $0 ? "링크 추가" : "링크 변경" }
            .bind(to: navigationView.rx.centerTitle)
            .disposed(by: disposeBag)
        
        reactor.state.map(\.isCreate)
            .bind(to: removeButton.rx.isHidden)
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
        
        nameTextField.rx.returnKeyDidTap
            .withUnretained(self.urlTextField)
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { nextTextField, _ in
                nextTextField.becomeFirstResponder()
            })
            .disposed(by: disposeBag)
        
        urlTextField.rx.returnKeyDidTap
            .withUnretained(self.descTextField)
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { nextTextField, _ in
                nextTextField.becomeFirstResponder()
            })
            .disposed(by: disposeBag)
    }
    
    private var keyboardShowBinder: Binder<CGRect> {
        return Binder(self) { this, keyboardSize in
            this.buttonStackViewBottomConstraint?.update(offset: -keyboardSize.height)
            UIView.animate(withDuration: 0.3) {
                this.view.layoutIfNeeded()
            }
        }
    }
    
    private var keyboardHideBinder: Binder<Notification> {
        return Binder(self) { this, _ in
            this.buttonStackViewBottomConstraint?.update(offset: -10)
            UIView.animate(withDuration: 0.3) {
                this.view.layoutIfNeeded()
            }
        }
    }
    
}
