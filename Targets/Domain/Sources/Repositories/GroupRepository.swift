//
//  GroupRepository.swift
//  Service
//
//  Created by 홍성준 on 2023/07/02.
//

import Foundation

public protocol GroupRepository {
    
    func fetchGroupList(request: GroupRequest) -> [Group]
    func insert(group: Group) throws
    func update(group: Group) throws
    func delete(group: Group) throws
    
}
