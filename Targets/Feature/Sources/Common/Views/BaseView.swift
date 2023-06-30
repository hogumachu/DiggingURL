//
//  BaseView.swift
//  Feature
//
//  Created by 홍성준 on 2023/06/30.
//

import UIKit

class BaseView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        setupAttributes()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {}
    func setupAttributes() {}
}
