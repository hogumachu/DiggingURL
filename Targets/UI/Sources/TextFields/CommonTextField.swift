//
//  CommonTextField.swift
//  UI
//
//  Created by 홍성준 on 2023/07/01.
//

import UIKit
import SnapKit
import Then

public final class CommonTextField: UITextField {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupTextField()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTextField() {
        backgroundColor = .monogray1
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.black.withAlphaComponent(0.2).cgColor
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: frame.height))
        leftView = paddingView
        leftViewMode = .always
        rightView = paddingView
        rightViewMode = .always
    }
    
}
