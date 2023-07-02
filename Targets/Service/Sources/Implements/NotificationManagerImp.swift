//
//  NotificationManagerImp.swift
//  Service
//
//  Created by 홍성준 on 2023/07/02.
//

import Foundation
import RxSwift
import RxRelay

final class NotificationManagerImp: NotificationManager {
    
    static let shared = NotificationManagerImp()
    private let repositoryUpdatedRelay = PublishRelay<RepositoryType>()
    var repositoryUpdatedObservable: Observable<RepositoryType> {
        repositoryUpdatedRelay.asObservable()
    }
    
    private init() {}
    
    func repositoryUpdateFinished(type: RepositoryType) {
        repositoryUpdatedRelay.accept(type)
    }
    
}
