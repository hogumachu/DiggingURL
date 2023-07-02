//
//  LinkCreateReactor.swift
//  Feature
//
//  Created by 홍성준 on 2023/07/02.
//

import Domain
import Service
import Foundation
import RxSwift
import ReactorKit

final class LinkCreateReactor: Reactor {
    
    var initialState: State = State(
        name: "",
        url: "",
        description: "",
        isEnabled: false
    )
    private let dependency: Dependency
    
    init(dependency: Dependency) {
        self.dependency = dependency
    }
    
    struct Dependency {
        let groupID: Date
        let coordinator: AppCoordinator
        let linkUseCase: LinkUseCase
        let notificationManager: NotificationManager
    }
    
    struct State {
        var name: String
        var url: String
        var description: String
        var isEnabled: Bool
    }
    
    enum Action {
        case nameDidUpdate(String)
        case urlDidUpdate(String)
        case descriptionDidUpdate(String)
        case addButtonTap
    }
    
    enum Mutation {
        case setName(String)
        case setURL(String)
        case setDescription(String)
        case setIsEnabled(Bool)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .nameDidUpdate(let name):
            let isEnabled = name.isEmpty == false && currentState.url.isEmpty == false
            return .merge([.just(.setIsEnabled(isEnabled)), .just(.setName(name))])
            
        case .urlDidUpdate(let url):
            let isEnabled = url.isEmpty == false && currentState.name.isEmpty == false
            return .merge([.just(.setIsEnabled(isEnabled)), .just(.setURL(url))])
            
        case .descriptionDidUpdate(let description):
            return .just(.setDescription(description))
            
        case .addButtonTap:
            do {
                try createLink()
                dependency.notificationManager.repositoryUpdateFinished(type: .link)
                dependency.coordinator.close(using: .dismiss, animated: true, completion: nil)
            } catch {
                print("# TODO: - Handle Error")
            }
            return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setName(let name):
            newState.name = name
            
        case .setURL(let url):
            newState.url = url
            
        case .setDescription(let description):
            newState.description = description
            
        case .setIsEnabled(let isEnabled):
            newState.isEnabled = isEnabled
        }
        
        return newState
    }
    
}

extension LinkCreateReactor {
    
    private func createLink() throws {
        let link = Link(
            groupID: dependency.groupID,
            name: currentState.name,
            url: currentState.url.lowercased(),
            description: currentState.description,
            visitCount: 0,
            isBookMarked: false,
            createdAt: Date()
        )
        try dependency.linkUseCase.insert(link: link)
    }
    
}
