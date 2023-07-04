//
//  HomeReactor.swift
//  Feature
//
//  Created by 홍성준 on 2023/06/30.
//

import Core
import Domain
import Service
import RxSwift
import ReactorKit

final class HomeReactor: Reactor {
    
    typealias Section = HomeSection
    typealias Item = HomeItem
    
    var initialState: State = State(sections: [])
    private let dependency: Dependency
    private let disposeBag = DisposeBag()
    
    init(dependency: Dependency) {
        self.dependency = dependency
        subscribeNotificationManager()
    }
    
    struct Dependency {
        let coordinator: AppCoordinator
        let groupUseCase: GroupUseCase
        let linkUseCase: LinkUseCase
        let notificationManager: NotificationManager
    }
    
    struct State {
        var sections: [Section]
    }
    
    enum Action {
        case refresh
        case itemSelected(Item)
        case itemLongPressed(Item)
        case settingButtonTap
        case plusButtonTap
    }
    
    enum Mutation {
        case setSections([Section])
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .refresh:
            let sections = makeSections()
            return .just(.setSections(sections))
            
        case .itemSelected(let item):
            itemSelected(item: item)
            return .empty()
            
        case .itemLongPressed(let item):
            itemLongPressed(item: item)
            return .empty()
            
        case .settingButtonTap:
            return .empty()
            
        case .plusButtonTap:
            dependency.coordinator.transition(to: .groupCreate, using: .modal, animated: true, completion: nil)
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

extension HomeReactor {
    
    private func itemSelected(item: Item) {
        switch item {
        case .group(let model):
            dependency.coordinator.transition(
                to: .homeGroupDetail(Group(name: model.group, createdAt: model.createdAt)),
                using: .push,
                animated: true,
                completion: nil
            )
            
        default:
            break
        }
    }
    
    private func itemLongPressed(item: Item) {
        switch item {
        case .group(let model):
            let group = Group(name: model.group, createdAt: model.createdAt)
            dependency.coordinator.transition(
                to: .groupEdit(group: group),
                using: .modal,
                animated: true,
                completion: nil
            )
            
        default:
            break
        }
    }
    
    private func makeSections() -> [Section] {
        var items: [Item] = []
        let groupItems = dependency.groupUseCase.fetchGroupList(request: .init())
            .map { group -> Item in
                let count = dependency.linkUseCase.fetchLinkList(request: .init(groupID: group.createdAt)).count
                return .group(.init(group: group.name, count: count, createdAt: group.createdAt))
            }
        items.append(.title("그룹"))
        items.append(contentsOf: groupItems)
        return [.group(items)]
    }
    
    private func subscribeNotificationManager() {
        dependency.notificationManager
            .repositoryUpdatedObservable
            .filter { $0 == .group }
            .map { _ in Action.refresh }
            .bind(to: action)
            .disposed(by: disposeBag)
    }
    
}
