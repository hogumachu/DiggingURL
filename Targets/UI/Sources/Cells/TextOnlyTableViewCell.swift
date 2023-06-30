//
//  TextOnlyTableViewCell.swift
//  UI
//
//  Created by 홍성준 on 2023/06/30.
//

import UIKit
import SnapKit
import Then

public final class TextOnlyTableViewCell: UITableViewCell {
    
    public let label = UILabel(frame: .zero)
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
        setupAttributes()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(text: String, inset: UIEdgeInsets = .zero) {
        label.text = text
        label.snp.remakeConstraints { make in
            make.edges.equalToSuperview().inset(inset)
        }
    }
    
    private func setupLayout() {
        contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupAttributes() {
        selectionStyle = .none
        backgroundColor = .clear
        
        label.do {
            $0.textColor = .monoblack
            $0.font = .headerB
            $0.textAlignment = .left
        }
    }
    
}
