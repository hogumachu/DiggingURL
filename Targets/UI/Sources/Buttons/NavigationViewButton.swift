//
//  NavigationViewButton.swift
//  UI
//
//  Created by 홍성준 on 2023/06/30.
//

import UIKit

public class NavigationViewButton: UIButton {
    
    public var imageTintColor: UIColor = .monoblack ?? .black {
        didSet {
            self.tintColor = self.imageTintColor
        }
    }
    
    public override var isHighlighted: Bool {
        didSet {
            if self.isHighlighted {
                self.tintColor = .systemGray
            } else {
                self.tintColor = self.imageTintColor
            }
        }
    }
    
}
