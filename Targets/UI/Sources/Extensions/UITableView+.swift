//
//  UITableView+.swift
//  UI
//
//  Created by 홍성준 on 2023/06/30.
//

import UIKit

extension UITableView {
    
    public func register<T: UITableViewCell>(_ cell: T.Type) {
        let identifier = String(describing: cell)
        register(cell, forCellReuseIdentifier: identifier)
    }
    
    public func dequeueCell<T: UITableViewCell>(_ cell: T.Type, for indexPath: IndexPath) -> T? {
        let identifier = String(describing: cell)
        return dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? T
    }
    
}
