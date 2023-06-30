//
//  UIApplication+.swift
//  UI
//
//  Created by 홍성준 on 2023/06/30.
//

import UIKit

extension UIApplication {
    
    public static var keyWindow: UIWindow? {
        return UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?
            .windows
            .filter { $0.isKeyWindow }
            .first
    }
    
}
