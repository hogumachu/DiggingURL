//
//  UIView+.swift
//  UI
//
//  Created by 홍성준 on 2023/06/30.
//

import UIKit
import SnapKit

extension UIView {
    
    public var safeArea: ConstraintBasicAttributesDSL {
        return self.safeAreaLayoutGuide.snp
    }
    
    public func maskRoundedRect(cornerRadius: CGFloat, corners: UIRectCorner) {
        let roundedRect = self.bounds
        let cornerRadii = CGSize(width: cornerRadius, height: cornerRadius)
        let path = UIBezierPath(
            roundedRect: roundedRect,
            byRoundingCorners: corners,
            cornerRadii: cornerRadii
        )
        
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    public func addLongPressGesture() -> UILongPressGestureRecognizer {
        let gesture = UILongPressGestureRecognizer()
        addGestureRecognizer(gesture)
        return gesture
    }
    
    public func addTapGesture() -> UITapGestureRecognizer {
        let gesture = UITapGestureRecognizer()
        addGestureRecognizer(gesture)
        return gesture
    }
    
}
