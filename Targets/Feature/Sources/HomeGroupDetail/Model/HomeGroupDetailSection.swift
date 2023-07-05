//
//  HomeGroupDetailSection.swift
//  Feature
//
//  Created by 홍성준 on 2023/06/30.
//

import RxDataSources

struct HomeGroupDetailSection {
    var items: [HomeGroupDetailItem]
}

enum HomeGroupDetailItem {
    case detail(HomeGroupDetailTableViewCellModel)
    case guide(GuideTableViewCellModel)
}

extension HomeGroupDetailSection: SectionModelType {

    init(original: HomeGroupDetailSection, items: [HomeGroupDetailItem]) {
        self = original
        self.items = items
    }
    
}
