//
//  LinkWebReactor.swift
//  Feature
//
//  Created by 홍성준 on 2023/06/30.
//

import Core
import RxSwift
import ReactorKit

final class LinkWebReactor: Reactor {
    
    var initialState: State
    private let dependency: Dependency
    
    init(dependency: Dependency) {
        initialState = State(title: dependency.title, url: dependency.url)
        self.dependency = dependency
    }
 
    struct Dependency {
        let coordinator: AppCoordinator
        let title: String
        let url: String
    }
    
    struct State {
        var title: String
        var url: String
    }
    
    enum Action {
        case navigationLeftButtonTap
    }
    
    enum Mutation {
        
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .navigationLeftButtonTap:
            dependency.coordinator.close(using: .dismiss, animated: true, completion: nil)
            return .empty()
        }
    }
    
}
