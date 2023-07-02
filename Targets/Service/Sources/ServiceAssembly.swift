//
//  ServiceAssembly.swift
//  Service
//
//  Created by 홍성준 on 2023/07/02.
//

import Domain
import Foundation
import Swinject
import RealmSwift

public struct ServiceAssembly: Assembly {
    
    public init() {}
    
    public func assemble(container: Container) {
        let realm = try! Realm()
        
        container.register(GroupRepository.self) { resolver in
            return GroupRepositoryImp(realm: realm)
        }
        
        container.register(LinkRepository.self) { resolver in
            return LinkRepositoryImp(realm: realm)
        }
        
        container.register(NotificationManager.self) { resolver in
            return NotificationManagerImp.shared
        }
    }
    
}
