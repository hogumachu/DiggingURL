//
//  NavigationView.swift
//  UI
//
//  Created by 홍성준 on 2023/06/30.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import RxRelay

public enum NavigationViewType {
    
    case title
    case titleWithRightButtons([NavigationViewRightButtonType])
    case back
    case backWithRightButtons([NavigationViewRightButtonType])
    case close
    
}

public enum NavigationViewRightButtonType {
    
    case search
    case setting
    case plus
    
    var image: UIImage? {
        switch self {
        case .search: return UIImage(named: "search")
        case .setting: return UIImage(named: "gear")
        case .plus: return UIImage(named: "plus")
        }
    }
    
    var tintColor: UIColor {
        switch self {
        case .search: return .monogray2 ?? .darkGray
        case .setting: return .monogray2 ?? .darkGray
        case .plus: return .monogray2 ?? .darkGray
        }
    }
    
}

extension NavigationViewType {
    
    var leftImage: UIImage? {
        switch self {
        case .title: return nil
        case .titleWithRightButtons: return nil
        case .back: return UIImage(systemName: "chevron.backward")
        case .backWithRightButtons: return UIImage(systemName: "chevron.backward")
        case .close: return UIImage(systemName: "xmark")
        }
    }
    
    var rightButtonTypes: [NavigationViewRightButtonType] {
        switch self {
        case .title: return []
        case .titleWithRightButtons(let types): return types
        case .back: return []
        case .backWithRightButtons(let types): return types
        case .close: return []
        }
    }
    
    var rightImages: [UIImage?] {
        switch self {
        case .title: return []
        case .titleWithRightButtons(let buttons): return buttons.map { $0.image }
        case .back: return []
        case .backWithRightButtons(let buttons): return buttons.map { $0.image }
        case .close: return []
        }
    }
    
    var leftImageTintColor: UIColor {
        return .monoblack ?? .black
    }
    
    var rightImageTintColors: [UIColor] {
        switch self {
        case .title: return []
        case .titleWithRightButtons(let buttons): return buttons.map { $0.tintColor }
        case .back: return []
        case .backWithRightButtons(let buttons): return buttons.map { $0.tintColor }
        case .close: return []
        }
    }
    
}

public struct NavigationViewModel {
    
    public let type: NavigationViewType
    public let title: String?
    public let font: UIFont?
    
    public init(type: NavigationViewType, title: String?, font: UIFont?) {
        self.type = type
        self.title = title
        self.font = font
    }
    
}

public final class NavigationView: UIView {
    
    public private(set) var model: NavigationViewModel?
    let leftTitleLabel = UILabel(frame: .zero)
    let centerTitleLabel = UILabel(frame: .zero)
    let leftButton = NavigationViewButton(frame: .zero)
    var rightButtons: [NavigationViewRightButton] = []
    let rightButtonStackView = UIStackView(frame: .zero)
    let separator = UIView(frame: .zero)
    let rightButtonRelay = PublishRelay<NavigationViewRightButtonType>()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        setupAttributes()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(_ model: NavigationViewModel) {
        self.model = model
        leftTitleLabel.text = nil
        centerTitleLabel.text = nil
        if case .titleWithRightButtons = model.type {
            leftTitleLabel.text = model.title
            leftTitleLabel.font = model.font
        } else {
            centerTitleLabel.text = model.title
            centerTitleLabel.font = model.font
        }
        
        leftButton.setImage(model.type.leftImage?.withRenderingMode(.alwaysTemplate), for: .normal)
        leftButton.imageTintColor = model.type.leftImageTintColor
        rightButtonStackView.subviews.forEach { $0.removeFromSuperview() }
        rightButtons.removeAll()
        rightButtons = model.type.rightButtonTypes.map { type -> NavigationViewRightButton in
            let button = NavigationViewRightButton(frame: .zero).then {
                $0.type = type
                $0.contentMode = .center
                $0.adjustsImageWhenHighlighted = true
                $0.addTarget(self, action: #selector(rightButtonDidTap(_:)), for: .touchUpInside)
                rightButtonStackView.addArrangedSubview($0)
                $0.snp.makeConstraints { make in
                    make.width.equalTo(40)
                }
            }
            return button
        }
    }
    
    public func showSeparator() {
        guard self.separator.alpha == 0 else { return }
        UIView.animate(withDuration: 0.1) {
            self.separator.alpha = 1.0
        }
    }
    
    public func hideSeparator() {
        guard self.separator.alpha == 1.0 else { return }
        UIView.animate(withDuration: 0.1) {
            self.separator.alpha = 0
        }
    }
    
    @objc private func rightButtonDidTap(_ sender: NavigationViewRightButton) {
        guard let type = sender.type else { return }
        rightButtonRelay.accept(type)
    }
    
    private func setupLayout() {
        addSubview(leftTitleLabel)
        leftTitleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
        }
        
        addSubview(centerTitleLabel)
        centerTitleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(66)
        }
        
        addSubview(leftButton)
        leftButton.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
            make.width.equalTo(52)
        }
        
        addSubview(rightButtonStackView)
        rightButtonStackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.trailing.equalToSuperview().offset(-20)
        }
        
        addSubview(separator)
        separator.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    private func setupAttributes() {
        backgroundColor = .clear
        
        leftTitleLabel.do {
            $0.isUserInteractionEnabled = false
            $0.textColor = .monoblack
            $0.font = .headerSB
            $0.textAlignment = .left
        }
        
        centerTitleLabel.do {
            $0.isUserInteractionEnabled = false
            $0.textColor = .monoblack
            $0.font = .bodySB
            $0.textAlignment = .center
        }
        
        leftButton.do {
            $0.tintColor = .white
            $0.contentMode = .center
            $0.adjustsImageWhenHighlighted = true
        }
        
        rightButtonStackView.do {
            $0.spacing = 3
            $0.axis = .horizontal
            $0.alignment = .center
            $0.distribution = .fillEqually
        }
        
        separator.do {
            $0.backgroundColor = .black.withAlphaComponent(0.05)
            $0.alpha = 0
        }
    }
    
}

public extension Reactive where Base: NavigationView {
    
    var leftTitle: Binder<String?> {
        return base.leftTitleLabel.rx.text
    }
    
    var centerTitle: Binder<String?> {
        return base.centerTitleLabel.rx.text
    }
    
    var leftButtonTap: ControlEvent<Void> {
        let source = base.leftButton.rx.tap
        return ControlEvent(events: source)
    }
    
    var rightButtonTap: ControlEvent<NavigationViewRightButtonType> {
        let source = base.rightButtonRelay.asObservable()
        return ControlEvent(events: source)
    }
    
}
