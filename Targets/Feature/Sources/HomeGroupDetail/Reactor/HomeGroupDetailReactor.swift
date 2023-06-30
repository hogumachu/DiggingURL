//
//  HomeGroupDetailReactor.swift
//  UI
//
//  Created by 홍성준 on 2023/06/30.
//

import Core
import RxSwift
import ReactorKit

final class HomeGroupDetailReactor: Reactor {
    
    typealias Section = HomeGroupDetailSection
    typealias Item = HomeGroupDetailItem
    
    var initialState: State
    private let dependency: Dependency
    
    init(dependency: Dependency) {
        self.initialState = State(
            title: dependency.group,
            sections: []
        )
        self.dependency = dependency
    }
    
    struct Dependency {
        let coordinator: AppCoordinator
        let group: String
    }
    
    struct State {
        var title: String
        var sections: [Section]
    }
    
    enum Action {
        case refresh
        case navigationLeftButtonTap
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
        let items: [Item] = [
            .init(cellModel: .init(title: "네이버 ", description: "네이버 링크입니다네이버 링크입니다네이버 링크입니다네이버 링크입니다네이버 링크입니다네이버 링크입니다네이버 링크입니다", link: "https://naver.com")),
            .init(cellModel: .init(title: "깃허브", description: "깃허브 링크입니다깃허브 링크입니다깃허브 링크입니다깃허브 링크입니다깃허브 링크입니다깃허브 링크입니다깃허브 링크입니다깃허브 링크입니다깃허브 링크입니다깃허브 링크입니다깃허브 링크입니다", link: "https://github.com")),
            .init(cellModel: .init(title: "호구마츄 깃허브", description: "호구마츄 깃허브 링크입니다호구마츄 깃허브 링크입니다호구마츄 깃허브 링크입니다호구마츄 깃허브 링크입니다호구마츄 깃허브 링크입니다호구마츄 깃허브 링크입니다호구마츄 깃허브 링크입니다호구마츄 깃허브 링크입니다호구마츄 깃허브 링크입니다호구마츄 깃허브 링크입니다", link: "https://github.com/hogumachu"))
        ]
        return [.init(items: items)]
    }
    
}
