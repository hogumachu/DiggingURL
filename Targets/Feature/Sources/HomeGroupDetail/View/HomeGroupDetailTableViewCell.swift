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
    private let faviconImageView = FaviconImageView(frame: .zero)
    private let labelStackView = UIStackView(frame: .zero)
    private let titleLabel = UILabel(frame: .zero)
    private let descriptionLabel = UILabel(frame: .zero)
    private let linkLabel = UILabel(frame: .zero)
    
    func configure(_ model: HomeGroupDetailTableViewCellModel) {
        titleLabel.text = model.title
        descriptionLabel.text = model.description
        linkLabel.text = model.link
        faviconImageView.configure(FaviconImageViewModel(size: .large, domain: model.link))
    }
    
    override func clear() {
        titleLabel.text = nil
        descriptionLabel.text = nil
        linkLabel.text = nil
        faviconImageView.image = nil
        faviconImageView.kf.cancelDownloadTask()
    }
    
    override func setupLayout() {
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            let inset = UIEdgeInsets(top: 0, left: 20, bottom: 20, right: 20)
            make.edges.equalToSuperview().inset(inset)
        }
        
        containerView.addSubview(faviconImageView)
        faviconImageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 50, height: 50))
            make.top.leading.bottom.equalToSuperview().inset(20)
        }
        
        containerView.addSubview(labelStackView)
        labelStackView.snp.makeConstraints { make in
            make.leading.equalTo(faviconImageView.snp.trailing).offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
        }
        
        labelStackView.addArrangedSubview(titleLabel)
        labelStackView.addArrangedSubview(descriptionLabel)
        labelStackView.addArrangedSubview(linkLabel)
    }
    
    override func setupAttributes() {
        backgroundColor = .clear
        selectionStyle = .none
        
        containerView.do {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 16
        }
        
        faviconImageView.do {
            $0.contentMode = .scaleAspectFill
            $0.layer.cornerRadius = 8
            $0.backgroundColor = .monogray1
            $0.clipsToBounds = true
        }
        
        labelStackView.do {
            $0.axis = .vertical
            $0.spacing = 3
            $0.distribution = .fill
            $0.alignment = .leading
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
