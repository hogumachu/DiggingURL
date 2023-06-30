//
//  ActionButton.swift
//  UI
//
//  Created by 홍성준 on 2023/06/30.
//

import UIKit
import SnapKit
import Then

public enum ActionButtonStyle {
    
    case normal
    case secondary
    case small
    case smallSecondary
    
    var defaultTextColor: UIColor? {
        switch self {
        case .normal: return .white
        case .secondary: return .blue1
        case .small: return .white
        case .smallSecondary: return .blue1
        }
    }
    
    var disabledTextColor: UIColor? {
        return .systemGray
    }
    
    var defaultBackgroundColor: UIColor? {
        switch self {
        case .normal: return .blue1
        case .secondary: return .monogray1
        case .small: return .blue1
        case .smallSecondary: return .monogray1
        }
    }
    
    var disabledBackgroundColor: UIColor? {
        return .monogray2
    }
    
    var font: UIFont? {
        return .bodySB
    }
    
    var disabledFont: UIFont? {
        return .bodySB
    }
    
}

public final class ActionButton: UIButton {
    
    public var style: ActionButtonStyle = .normal {
        didSet {
            updateFont()
            updateTextColor()
            updateBackgroundColor()
        }
    }
    
    public override var isHighlighted: Bool {
        didSet {
            pressedView.isHidden = !isHighlighted
        }
    }
    
    public override var isEnabled: Bool {
        didSet {
            backgroundColor = isEnabled ? style.defaultBackgroundColor : style.disabledBackgroundColor
            updateFont()
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupAttributes()
        setupPressedView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupAttributes() {
        layer.borderColor = UIColor.black.withAlphaComponent(0.05).cgColor
        layer.borderWidth = 1
        clipsToBounds = true
        
        backgroundColor = self.style.defaultBackgroundColor
        setTitleColor(self.style.defaultTextColor, for: .normal)
        setTitleColor(self.style.disabledTextColor, for: .disabled)
        contentEdgeInsets = UIEdgeInsets(top: 10, left: 12, bottom: 10, right: 12)
    }
    
    private func setupPressedView() {
        addSubview(self.pressedView)
        pressedView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        pressedView.do {
            $0.backgroundColor = .black.withAlphaComponent(0.1)
            $0.isUserInteractionEnabled = false
            $0.isHidden = true
        }
    }
    
    private func updateFont() {
        titleLabel?.font = isEnabled ? style.font : style.disabledFont
    }
    
    private func updateTextColor() {
        setTitleColor(style.defaultTextColor, for: .normal)
        setTitleColor(style.disabledTextColor, for: .disabled)
    }
    
    private func updateBackgroundColor() {
        backgroundColor = style.defaultBackgroundColor
        if isHighlighted {
            pressedView.isHidden = !isHighlighted
        }
        
        if isEnabled == false {
            backgroundColor = style.disabledBackgroundColor
        }
    }
    
    private let pressedView = UIView(frame: .zero)
    
}
