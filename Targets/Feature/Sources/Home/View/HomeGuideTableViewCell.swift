//
//  HomeGuideTableViewCell.swift
//  Feature
//
//  Created by 홍성준 on 2023/07/05.
//

import UI
import UIKit
import SnapKit
import Then

struct HomeGuidTableViewCellModel {
    let title: String
    let subtitle: String
}

final class HomeGuideTableViewCell: BaseTableViewCell {
    
    private let titleLabel = UILabel(frame: .zero)
    private let subtitleLabel = UILabel(frame: .zero)
    
    func configure(_ model: HomeGuidTableViewCellModel) {
        titleLabel.text = model.title
        subtitleLabel.text = model.subtitle
    }
    
    override func clear() {
        titleLabel.text = nil
        subtitleLabel.text = nil
    }
    
    override func setupLayout() {
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        contentView.addSubview(subtitleLabel)
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(3)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
        }
    }
    
    override func setupAttributes() {
        backgroundColor = .clear
        selectionStyle = .none
        
        titleLabel.do {
            $0.textColor = .monoblack
            $0.font = .bodySB
            $0.numberOfLines = 0
            $0.textAlignment = .center
        }
        
        subtitleLabel.do {
            $0.textColor = .monogray2
            $0.font = .captionR
            $0.numberOfLines = 0
            $0.textAlignment = .center
        }
    }
    
}
