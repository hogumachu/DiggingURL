//
//  NavigationViewRightButton.swift
//  UI
//
//  Created by 홍성준 on 2023/06/30.
//

import UIKit

public final class NavigationViewRightButton: NavigationViewButton {
    
    public var type: NavigationViewRightButtonType? {
        didSet {
            guard let type else { return }
            self.setImage(type.image?.withRenderingMode(.alwaysTemplate), for: .normal)
            self.imageTintColor = type.tintColor
        }
    }
    
}
