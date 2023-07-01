//
//  FaviconImageView.swift
//  UI
//
//  Created by 홍성준 on 2023/07/01.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import Kingfisher

public enum FaviconImageSize: Int {
    case small = 16
    case medium = 32
    case large = 64
}

public struct FaviconImageViewModel {
    let size: FaviconImageSize
    let domain: String
    
    public init(size: FaviconImageSize, domain: String) {
        self.size = size
        self.domain = domain
    }
}

public final class FaviconImageView: UIImageView {
    
    public var model: Binder<FaviconImageViewModel> {
        return Binder(self) { this, model in
            this.configure(model)
        }
    }
    
    public func configure(_ model: FaviconImageViewModel) {
        let urlStr = "https://www.google.com/s2/favicons?sz=\(model.size.rawValue)&domain=\(model.domain)"
        guard let url = URL(string: urlStr) else { return }
        kf.setImage(with: url)
    }
    
}
