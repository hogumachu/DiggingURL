//
//  LinkRepositoryImp.swift
//  Service
//
//  Created by 홍성준 on 2023/07/02.
//

import Domain
import Foundation
import RealmSwift

public final class LinkRepositoryImp: LinkRepository {
    
    private let realm: Realm
    
    public init(realm: Realm) {
        self.realm = realm
    }
    
    public func fetchLinkList(request: LinkRequest) -> [Link] {
        var objects = realm.objects(LinkObject.self)
        
        if let predicate = request.predicate {
            objects = objects.filter(predicate)
        }
        
        return objects
            .compactMap { $0.model }
    }
    
    public func insert(link: Link) throws {
        try realm.write {
            let object = link.object()
            realm.add(object)
        }
    }
    
    public func update(link: Link) throws {
        try delete(link: link)
        try insert(link: link)
    }
    
    public func delete(link: Link) throws {
        try realm.write {
            guard let object = realm.objects(LinkObject.self)
                .filter({ $0.groupID == link.groupID && $0.url == link.url })
                .first
            else {
                return
            }
            realm.delete(object)
        }
    }
    
}
