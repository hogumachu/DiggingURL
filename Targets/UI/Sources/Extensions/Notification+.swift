//
//  Notification+.swift
//  UI
//
//  Created by 홍성준 on 2023/06/30.
//

import UIKit

extension Notification {
    
    public var keyboardSize: CGRect? {
        return (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
    }
    
}
