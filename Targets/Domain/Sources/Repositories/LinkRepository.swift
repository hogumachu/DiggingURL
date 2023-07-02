//
//  LinkRepository.swift
//  Domain
//
//  Created by 홍성준 on 2023/07/02.
//

import Foundation

public protocol LinkRepository {
    
    func fetchLinkList(request: LinkRequest) -> [Link]
    func insert(link: Link) throws
    func update(link: Link) throws
    func delete(link: Link) throws
    
}
