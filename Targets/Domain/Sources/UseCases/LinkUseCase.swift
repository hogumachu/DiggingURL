//
//  LinkUseCase.swift
//  Domain
//
//  Created by 홍성준 on 2023/07/02.
//

import Foundation

public protocol LinkUseCase {
    
    func fetchLinkList(request: LinkRequest) -> [Link]
    func insert(link: Link) throws
    func update(link: Link) throws
    func delete(link: Link) throws
    
}

final class LinkUseCaseImp: LinkUseCase {
    
    private let repository: LinkRepository
    
    init(repository: LinkRepository) {
        self.repository = repository
    }
    
    func fetchLinkList(request: LinkRequest) -> [Link] {
        repository.fetchLinkList(request: request)
    }
    
    func insert(link: Link) throws {
        try repository.insert(link: link)
    }
    
    func update(link: Link) throws {
        try repository.update(link: link)
    }
    
    func delete(link: Link) throws {
        try repository.delete(link: link)
    }
    
}
