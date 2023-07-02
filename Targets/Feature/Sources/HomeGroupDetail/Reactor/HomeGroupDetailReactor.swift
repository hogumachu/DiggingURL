//
//  HomeGroupDetailReactor.swift
//  UI
//
//  Created by 홍성준 on 2023/06/30.
//

import Core
import Domain
import Service
import RxSwift
import ReactorKit

final class HomeGroupDetailReactor: Reactor {
    
    typealias Section = HomeGroupDetailSection
    typealias Item = HomeGroupDetailItem
    
    var initialState: State
    private let dependency: Dependency
    private let disposeBag = DisposeBag()
    
    init(dependency: Dependency) {
        self.initialState = State(
            title: dependency.group.name,
            sections: []
        )
        self.dependency = dependency
        subscribeNotificationManager()
    }
    
    struct Dependency {
        let coordinator: AppCoordinator
        let group: Group
        let linkUseCase: LinkUseCase
        let notificationManager: NotificationManager
    }
    
    struct State {
        var title: String
        var sections: [Section]
    }
    
    enum Action {
        case refresh
        case navigationLeftButtonTap
        case addButtonTap
        case itemSelected(Item)
    }
    
    enum Mutation {
        case setSections([Section])
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .refresh:
            let sections = makeSections()
            return .just(.setSections(sections))
            
        case .navigationLeftButtonTap:
            dependency.coordinator.close(using: .pop, animated: true, completion: nil)
            return .empty()
            
        case .addButtonTap:
            dependency.coordinator.transition(
                to: .linkCreate(groupID: dependency.group.createdAt),
                using: .modal,
                animated: true,
                completion: nil
            )
            return .empty()
            
        case .itemSelected(let item):
            let title = item.cellModel.title
            let url = item.cellModel.link
            dependency.coordinator.transition(to: .linkWeb(title: title, url: url), using: .modal, animated: true, completion: nil)
            return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setSections(let sections):
            newState.sections = sections
        }
        
        return newState
    }
    
}

extension HomeGroupDetailReactor {
    
    private func makeSections() -> [Section] {
        let items = dependency.linkUseCase.fetchLinkList(request: .init(groupID: dependency.group.createdAt))
            .map { link -> Item in
                return .init(cellModel: .init(title: link.name, description: link.description, link: link.url))
            }
        return [.init(items: items)]
    }
    
    private func subscribeNotificationManager() {
        dependency.notificationManager
            .repositoryUpdatedObservable
            .map { _ in Action.refresh }
            .bind(to: action)
            .disposed(by: disposeBag)
    }
    
    
}
