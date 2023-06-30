//
//  HomeSection.swift
//  Feature
//
//  Created by 홍성준 on 2023/06/30.
//

import RxDataSources

enum HomeSection {
    case group([HomeItem])
}

enum HomeItem {
    case title(String)
    case group(HomeGroupTableViewCellModel)
}

extension HomeSection: SectionModelType {
    
    var items: [HomeItem] {
        switch self {
        case .group(let items): return items
        }
    }
    
    init(original: HomeSection, items: [HomeItem]) {
        self = original
    }
    
}
