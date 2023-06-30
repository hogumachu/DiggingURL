//
//  HomeReactor.swift
//  Feature
//
//  Created by 홍성준 on 2023/06/30.
//

import Core
import RxSwift
import ReactorKit

final class HomeReactor: Reactor {
    
    var initialState: State = State()
    private let dependency: Dependency
    
    init(dependency: Dependency) {
        self.dependency = dependency
    }
    
    struct Dependency {
        
    }
    
    enum Action {
        
    }
    
    enum Mutation {
        
    }
    
    struct State {
        
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        
    }
    
}
