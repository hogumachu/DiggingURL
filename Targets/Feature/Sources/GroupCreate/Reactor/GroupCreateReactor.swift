//
//  GroupCreateReactor.swift
//  Feature
//
//  Created by 홍성준 on 2023/07/01.
//

import Core
import Domain
import Service
import Foundation
import RxSwift
import ReactorKit

final class GroupCreateReactor: Reactor {
    
    var initialState: State
    private let dependency: Dependency
    
    init(dependency: Dependency) {
        var state: State
        if let group = dependency.group {
            state = State(name: group.name, isEnabled: true, isCreate: false)
        } else {
            state = State(name: "", isEnabled: false, isCreate: true)
        }
        
        self.initialState = state
        self.dependency = dependency
    }
    
    struct Dependency {
        let group: Group?
        let coordinator: AppCoordinator
        let groupUseCase: GroupUseCase
        let notifictionManger: NotificationManager
    }
    
    struct State {
        var name: String
        var isEnabled: Bool
        var isCreate: Bool
    }
    
    enum Action {
        case navigationLeftButtonTap
        case addButtonDidTap
        case removeButtonTap
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
            do {
                try createGroup()
                dependency.notifictionManger.repositoryUpdateFinished(type: .group)
                dependency.coordinator.close(using: .dismiss, animated: true, completion: nil)
            } catch {
                print("# TODO: - HANDLE ERROR")
            }
            
            return .empty()
            
        case .removeButtonTap:
            do {
                try removeGroup()
                dependency.notifictionManger.repositoryUpdateFinished(type: .group)
                dependency.coordinator.close(using: .dismiss, animated: true, completion: nil)
            } catch {
                print("# TODO: - HANDLE ERROR")
            }
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
            newState.name = text
            
        case .updateIsEnabled(let isEnabled):
            newState.isEnabled = isEnabled
        }
        
        return newState
    }
    
}

extension GroupCreateReactor {
    
    private func createGroup() throws {
        let createdAt = Date()
        let name = currentState.name
        let group = Group(name: name, createdAt: createdAt)
        try dependency.groupUseCase.insert(group: group)
    }
    
    private func removeGroup() throws {
        guard let group = dependency.group else {
            return
        }
        try dependency.groupUseCase.delete(group: group)
    }
    
}
