//
//  HomeGroupDetailTableViewCell.swift
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

struct HomeGroupDetailTableViewCellModel {
    let title: String
    let description: String?
    let link: String
}

final class HomeGroupDetailTableViewCell: BaseTableViewCell {
    
    private let containerView = UIView(frame: .zero)
    private let titleLabel = UILabel(frame: .zero)
    private let descriptionLabel = UILabel(frame: .zero)
    private let linkLabel = UILabel(frame: .zero)
    
    func configure(_ model: HomeGroupDetailTableViewCellModel) {
        titleLabel.text = model.title
        descriptionLabel.text = model.description
        linkLabel.text = model.link
    }
    
    override func clear() {
        titleLabel.text = nil
        descriptionLabel.text = nil
        linkLabel.text = nil
    }
    
    override func setupLayout() {
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            let inset = UIEdgeInsets(top: 0, left: 20, bottom: 20, right: 20)
            make.edges.equalToSuperview().inset(inset)
        }
        
        containerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(20)
        }
        
        containerView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(3)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        containerView.addSubview(linkLabel)
        linkLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(3)
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
        
        titleLabel.do {
            $0.textColor = .blue1
            $0.font = .bodyB
            $0.numberOfLines = 1
        }
        
        descriptionLabel.do {
            $0.textColor = .monoblack
            $0.font = .captionR
            $0.numberOfLines = 1
        }
        
        linkLabel.do {
            $0.textColor = .monogray2
            $0.font = .captionR
            $0.numberOfLines = 1
        }
    }
    
}
