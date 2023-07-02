//
//  GroupUseCase.swift
//  Domain
//
//  Created by 홍성준 on 2023/07/02.
//

import Foundation

public protocol GroupUseCase {
    
    func fetchGroupList(request: GroupRequest) -> [Group]
    func insert(group: Group) throws
    func update(group: Group) throws
    func delete(group: Group) throws
    
}

final class GroupUseCaseImp: GroupUseCase {
    
    private let repository: GroupRepository
    
    init(repository: GroupRepository) {
        self.repository = repository
    }
    
    func fetchGroupList(request: GroupRequest) -> [Group] {
        repository.fetchGroupList(request: request)
    }
    
    func insert(group: Group) throws {
        try repository.insert(group: group)
    }
    
    func update(group: Group) throws {
        try repository.update(group: group)
    }
    
    func delete(group: Group) throws {
        try repository.delete(group: group)
    }
    
}
