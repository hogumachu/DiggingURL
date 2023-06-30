//
//  UITableView+Rx.swift
//  UI
//
//  Created by 홍성준 on 2023/06/30.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

extension Reactive where Base: UITableView {
    
    public func itemSelected<T>(dataSource: TableViewSectionedDataSource<T>) -> ControlEvent<T.Item> {
        let source = itemSelected.map { dataSource[$0] }
        return ControlEvent(events: source)
    }
    
}
