//
//  UITextField+Rx.swift
//  UI
//
//  Created by 홍성준 on 2023/07/03.
//

import UIKit
import RxSwift
import RxCocoa

public extension Reactive where Base: UITextField {
    
    var returnKeyDidTap: ControlEvent<Void> {
        let source = RxTextFieldDelegateProxy.proxy(for: base).returnKeyDidTapPublishSubject
        return ControlEvent(events: source)
        
    }
    
}
