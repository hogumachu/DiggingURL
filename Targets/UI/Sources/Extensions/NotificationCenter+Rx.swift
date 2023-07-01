//
//  NotificationCenter+Rx.swift
//  UI
//
//  Created by 홍성준 on 2023/07/01.
//

import UIKit
import RxSwift

extension Reactive where Base: NotificationCenter {
    
    public var keyboardWillShow: Observable<Notification> {
        return base.rx.notification(UIResponder.keyboardWillShowNotification)
    }
    
    public var keyboardWillHide: Observable<Notification> {
        return base.rx.notification(UIResponder.keyboardWillHideNotification)
    }
}
