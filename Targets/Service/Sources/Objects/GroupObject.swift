//
//  GroupObject.swift
//  Service
//
//  Created by 홍성준 on 2023/07/02.
//

import Domain
import RealmSwift

final class GroupObject: Object {
    
    @Persisted private(set) var name: String
    
    convenience init(group: Group) {
        self.init()
        self.name = group.name
    }
    
    var model: Group {
        return Group(name: self.name)
    }
    
}

extension Group {
    
    func object() -> GroupObject {
        return GroupObject(group: self)
    }
}
