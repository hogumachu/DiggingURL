//
//  HomeGroupTableViewCell.swift
//  Feature
//
//  Created by 홍성준 on 2023/06/30.
//

import UI
import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

struct HomeGroupTableViewCellModel {
    let group: String
    let count: Int
    let createdAt: Date
}

final class HomeGroupTableViewCell: BaseTableViewCell {
    
    private let containerView = UIView(frame: .zero)
    private let groupLabel = UILabel(frame: .zero)
    private let countLabel = UILabel(frame: .zero)
    
    func configure(_ model: HomeGroupTableViewCellModel) {
        groupLabel.text = model.group
        countLabel.text = "\(model.count)개"
    }
    
    override func clear() {
        groupLabel.text = nil
        countLabel.text = nil
    }
    
    override func setupLayout() {
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            let inset = UIEdgeInsets(top: 0, left: 20, bottom: 20, right: 20)
            make.edges.equalToSuperview().inset(inset)
        }
        
        containerView.addSubview(groupLabel)
        groupLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(20)
        }
        
        containerView.addSubview(countLabel)
        countLabel.snp.makeConstraints { make in
            make.top.equalTo(groupLabel.snp.bottom).offset(3)
            make.leading.trailing.bottom.equalToSuperview().inset(20)
        }
    }
    
    override func setupAttributes() {
        backgroundColor = .clear
        selectionStyle = .none
        
        containerView.do {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 16
        }
        
        groupLabel.do {
            $0.textColor = .monoblack
            $0.font = .bodySB
            $0.numberOfLines = 0
        }
        
        countLabel.do {
            $0.textColor = .blue1
            $0.font = .captionSB
            $0.numberOfLines = 1
        }
    }
    
}
