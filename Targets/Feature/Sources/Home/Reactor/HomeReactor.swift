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
    
    typealias Section = HomeSection
    typealias Item = HomeItem
    
    var initialState: State = State(sections: [])
    private let dependency: Dependency
    
    init(dependency: Dependency) {
        self.dependency = dependency
    }
    
    struct Dependency {
        let coordinator: AppCoordinator
    }
    
    struct State {
        var sections: [Section]
    }
    
    enum Action {
        case refresh
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
            
        case .itemSelected(let item):
            switch item {
            case .group(let model):
                dependency.coordinator.transition(
                    to: .homeGroupDetail(model.group),
                    using: .push,
                    animated: true,
                    completion: nil
                )
                
            default:
                break
            }
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
    
    private func makeSections() -> [Section] {
        var items: [Item] = []
        items.append(.title("그룹"))
        items.append(contentsOf: [
            .group(.init(group: "Swift", count: 5)),
            .group(.init(group: "iOS", count: 10)),
            .group(.init(group: "CS", count: 11)),
            .group(.init(group: "Operation System", count: 4))
        ])
        return [.group(items)]
    }
    
}
