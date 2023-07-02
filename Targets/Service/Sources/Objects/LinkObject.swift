//
//  LinkObject.swift
//  Service
//
//  Created by 홍성준 on 2023/07/02.
//

import Domain
import Foundation
import RealmSwift

final class LinkObject: Object {
    
    @Persisted var groupID: Date
    @Persisted var name: String
    @Persisted var url: String
    @Persisted var desc: String
    @Persisted var visitCount: Int
    @Persisted var isBookMarked: Bool
    @Persisted var createdAt: Date
    
    convenience init(link: Link) {
        self.init()
        self.groupID = link.groupID
        self.name = link.name
        self.url = link.url
        self.desc = link.description
        self.visitCount = link.visitCount
        self.isBookMarked = link.isBookMarked
        self.createdAt = link.createdAt
    }
    
    var model: Link {
        return Link(
            groupID: self.groupID,
            name: self.name,
            url: self.url,
            description: self.desc,
            visitCount: self.visitCount,
            isBookMarked: self.isBookMarked,
            createdAt: self.createdAt
        )
    }
    
}

extension Link {
    
    func object() -> LinkObject {
        return LinkObject(link: self)
    }
    
}
