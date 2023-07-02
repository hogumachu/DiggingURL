//
//  GroupObject.swift
//  Service
//
//  Created by 홍성준 on 2023/07/02.
//

import Domain
import Foundation
import RealmSwift

final class GroupObject: Object {
    
    @Persisted var name: String
    @Persisted var createdAt: Date
    
    convenience init(group: Group) {
        self.init()
        self.name = group.name
        self.createdAt = group.createdAt
    }
    
    var model: Group {
        return Group(
            name: self.name,
            createdAt: self.createdAt
        )
    }
    
}

extension Group {
    
    func object() -> GroupObject {
        return GroupObject(group: self)
    }
}
