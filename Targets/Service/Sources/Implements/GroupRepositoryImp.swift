//
//  GroupRepositoryImp.swift
//  Service
//
//  Created by 홍성준 on 2023/07/02.
//

import Domain
import Foundation
import RealmSwift

public final class GroupRepositoryImp: GroupRepository {
    
    private let realm: Realm
    
    public init(realm: Realm) {
        self.realm = realm
    }
    
    public func fetchGroupList(request: GroupRequest) -> [Group] {
        var objects = realm.objects(GroupObject.self)
        
        if let predicate = request.predicate {
            objects = objects.filter(predicate)
        }
        
        return objects
            .compactMap { $0.model }
    }
    
    public func insert(group: Group) throws {
        try realm.write {
            let object = group.object()
            realm.add(object)
        }
    }
    
    public func update(group: Group) throws {
        guard let object = realm.objects(GroupObject.self)
            .filter({ $0.createdAt == group.createdAt })
            .first
        else {
            return
        }
        
        try realm.write {
            object.name = group.name
        }
    }
    
    public func delete(group: Group) throws {
        try realm.write {
            guard let object = realm.objects(GroupObject.self)
                .filter({ $0.createdAt == group.createdAt })
                .first
            else {
                return
            }
            realm.objects(LinkObject.self)
                .filter({ $0.groupID == group.createdAt })
                .forEach { linkObject in
                    realm.delete(linkObject)
                }
        
            realm.delete(object)
        }
    }
    
}
