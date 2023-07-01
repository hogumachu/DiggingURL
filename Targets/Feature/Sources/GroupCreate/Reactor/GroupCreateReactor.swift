//
//  GroupCreateReactor.swift
//  Feature
//
//  Created by 홍성준 on 2023/07/01.
//

import Core
import RxSwift
import ReactorKit

final class GroupCreateReactor: Reactor {
    
    var initialState: State = State(
        group: "",
        isEnabled: false
    )
    private let dependency: Dependency
    
    init(dependency: Dependency) {
        self.dependency = dependency
    }
    
    struct Dependency {
        let coordinator: AppCoordinator
    }
    
    struct State {
        var group: String
        var isEnabled: Bool
    }
    
    enum Action {
        case navigationLeftButtonTap
        case addButtonDidTap
        case groupTextDidChange(String)
    }
    
    enum Mutation {
        case updateGroup(String)
        case updateIsEnabled(Bool)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .navigationLeftButtonTap:
            dependency.coordinator.close(using: .dismiss, animated: true, completion: nil)
            return .empty()
            
        case .addButtonDidTap:
            // TODO: - Create Group
            dependency.coordinator.close(using: .dismiss, animated: true, completion: nil)
            return .empty()
            
        case .groupTextDidChange(let text):
            return .merge([
                .just(.updateIsEnabled(text.isEmpty == false)),
                .just(.updateGroup(text))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .updateGroup(let text):
            newState.group = text
            
        case .updateIsEnabled(let isEnabled):
            newState.isEnabled = isEnabled
        }
        
        return newState
    }
    
}
