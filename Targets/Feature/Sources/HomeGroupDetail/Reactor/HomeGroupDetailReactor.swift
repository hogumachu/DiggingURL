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
        case itemLongPressed(Item)
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
            switch item {
            case .detail(let model):
                let title = model.title
                let url = model.link
                updateLinkVisitCountIfEnabled(using: model)
                dependency.coordinator.transition(to: .linkWeb(title: title, url: url), using: .modal, animated: true, completion: nil)
                
            default:
                break
            }
            return .empty()
            
        case .itemLongPressed(let item):
            switch item {
            case .detail(let model):
                let link = model.toLink()
                dependency.coordinator.transition(
                    to: .linkEdit(groupID: dependency.group.createdAt, link: link),
                    using: .modal,
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

extension HomeGroupDetailReactor {
    
    private func makeSections() -> [Section] {
        let items = dependency.linkUseCase.fetchLinkList(request: .init(groupID: dependency.group.createdAt))
            .map { Item.detail($0.toModel()) }
        if items.isEmpty {
            return [.init(items: [.guide(.init(title: "추가된 링크가 없어요", subtitle: "하단의 버튼을 눌러 링크를 추가해주세요"))])]
        } else {
            return [.init(items: items)]
        }
    }
    
    private func subscribeNotificationManager() {
        dependency.notificationManager
            .repositoryUpdatedObservable
            .map { _ in Action.refresh }
            .bind(to: action)
            .disposed(by: disposeBag)
    }
    
    private func updateLinkVisitCountIfEnabled(using model: HomeGroupDetailTableViewCellModel) {
        let visitCount = model.visitCount + 1
        let link = model.toLink(visitCount: visitCount)
        try? dependency.linkUseCase.update(link: link)
    }
    
}

private extension HomeGroupDetailTableViewCellModel {
    
    func toLink(visitCount: Int? = nil) -> Link {
        return Link(
            groupID: self.groupID,
            name: self.title,
            url: self.link,
            description: self.description ?? "",
            visitCount: visitCount ?? self.visitCount,
            isBookMarked: self.isBookMarked,
            createdAt: self.createdAt
        )
    }
    
}

private extension Link {
    
    func toModel() -> HomeGroupDetailTableViewCellModel {
        return HomeGroupDetailTableViewCellModel(
            groupID: self.groupID,
            title: self.name,
            description: self.description,
            link: self.url,
            visitCount: self.visitCount,
            isBookMarked: self.isBookMarked,
            createdAt: self.createdAt
        )
    }
    
}
