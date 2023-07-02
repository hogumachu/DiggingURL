//
//  DomainAssembly.swift
//  Domain
//
//  Created by 홍성준 on 2023/07/02.
//

import Foundation
import Swinject

public struct DomainAssembly: Assembly {
    
    public init() {}
    
    public func assemble(container: Container) {
        container.register(GroupUseCase.self) { resolver in
            let repository = resolver.resolve(GroupRepository.self)!
            return GroupUseCaseImp(repository: repository)
        }
        
        container.register(LinkUseCase.self) { resolver in
            let repository = resolver.resolve(LinkRepository.self)!
            return LinkUseCaseImp(repository: repository)
        }
    }
    
}
