//
//  LinkWebNavigationView.swift
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

final class LinkWebNavigationView: BaseView {
    
    let backButton = NavigationViewButton(frame: .zero)
    let forwardButton = NavigationViewButton(frame: .zero)
    let refreshButton = NavigationViewButton(frame: .zero)
    let faviconImageView = FaviconImageView(frame: .zero)
    private let topSeparator = UIView(frame: .zero)
    private let bottomSeparator = UIView(frame: .zero)
    
    override func setupLayout() {
        addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.width.equalTo(52)
            make.leading.equalToSuperview()
        }
        
        addSubview(forwardButton)
        forwardButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.width.equalTo(52)
            make.leading.equalTo(backButton.snp.trailing).offset(10)
        }
        
        addSubview(faviconImageView)
        faviconImageView.snp.makeConstraints { make in
            make.size.equalTo(25)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-20)
        }
        
        addSubview(refreshButton)
        refreshButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.width.equalTo(52)
            make.trailing.equalTo(faviconImageView.snp.leading).offset(-10)
        }
        
        addSubview(topSeparator)
        topSeparator.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.top.leading.trailing.equalToSuperview()
        }
        
        addSubview(bottomSeparator)
        bottomSeparator.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    override func setupAttributes() {
        backButton.do {
            $0.setImage(UIImage(systemName: "chevron.backward")?.withRenderingMode(.alwaysTemplate), for: .normal)
            $0.imageTintColor = .monogray2 ?? .darkGray
            $0.contentMode = .center
            $0.adjustsImageWhenHighlighted = true
        }
        
        forwardButton.do {
            $0.setImage(UIImage(systemName: "chevron.forward")?.withRenderingMode(.alwaysTemplate), for: .normal)
            $0.imageTintColor = .monogray2 ?? .darkGray
            $0.contentMode = .center
            $0.adjustsImageWhenHighlighted = true
        }
        
        refreshButton.do {
            $0.setImage(UIImage(systemName: "arrow.clockwise")?.withRenderingMode(.alwaysTemplate), for: .normal)
            $0.imageTintColor = .monogray2 ?? .darkGray
            $0.contentMode = .center
            $0.adjustsImageWhenHighlighted = true
        }
        
        faviconImageView.do {
            $0.backgroundColor = .monogray1
            $0.contentMode = .scaleAspectFit
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 4
        }
        
        topSeparator.do {
            $0.backgroundColor = .black.withAlphaComponent(0.05)
        }
        
        bottomSeparator.do {
            $0.backgroundColor = .black.withAlphaComponent(0.05)
        }
    }
    
}

extension Reactive where Base: LinkWebNavigationView {
    
    var backButtonTap: ControlEvent<Void> {
        let source = base.backButton.rx.tap
        return ControlEvent(events: source)
    }
    
    var forwardButtonTap: ControlEvent<Void> {
        let source = base.forwardButton.rx.tap
        return ControlEvent(events: source)
    }
    
    var refreshButtonTap: ControlEvent<Void> {
        let source = base.refreshButton.rx.tap
        return ControlEvent(events: source)
    }
    
}
