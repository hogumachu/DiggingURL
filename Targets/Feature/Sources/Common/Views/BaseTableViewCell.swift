//
//  BaseTableViewCell.swift
//  Feature
//
//  Created by 홍성준 on 2023/06/30.
//

import UIKit
import RxSwift

class BaseTableViewCell: UITableViewCell {
    
    var disposBag = DisposeBag()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
        setupAttributes()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        clear()
        disposBag = DisposeBag()
    }
    
    func clear() {}
    func setupLayout() {}
    func setupAttributes() {}
    
}
