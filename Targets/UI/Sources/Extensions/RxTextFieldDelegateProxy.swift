//
//  RxTextFieldDelegateProxy.swift
//  UI
//
//  Created by 홍성준 on 2023/07/03.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay

extension UITextField: HasDelegate {
    public typealias Delegate = UITextFieldDelegate
}

open class RxTextFieldDelegateProxy: DelegateProxy<UITextField, UITextFieldDelegate>, DelegateProxyType {
    
    public weak private(set) var textField: UITextField?
    
    public init(textField: ParentObject) {
        self.textField = textField
        super.init(parentObject: textField, delegateProxy: RxTextFieldDelegateProxy.self)
    }
    
    public static func registerKnownImplementations() {
        self.register { RxTextFieldDelegateProxy(textField: $0) }
    }
    
    private var _returnKeyDidTapPublishSubject: PublishSubject<()>?
    
    internal var returnKeyDidTapPublishSubject: PublishSubject<()> {
        if let subject = _returnKeyDidTapPublishSubject {
            return subject
        }
        let subject = PublishSubject<()>()
        _returnKeyDidTapPublishSubject = subject
        return subject
    }
    
    deinit {
        if let subject = _returnKeyDidTapPublishSubject {
            subject.on(.completed)
        }
    }
    
}

extension RxTextFieldDelegateProxy: UITextFieldDelegate {
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let subject = _returnKeyDidTapPublishSubject {
            subject.on(.next(()))
        }
        return self._forwardToDelegate?.textFieldShouldReturn(textField) ?? true
    }
    
}
