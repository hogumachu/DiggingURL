//
//  NotificationManager.swift
//  Service
//
//  Created by 홍성준 on 2023/07/02.
//

import Foundation
import RxSwift

public enum RepositoryType {
    case group
    case link
}

public protocol NotificationManager: AnyObject {
    var repositoryUpdatedObservable: Observable<RepositoryType> { get }
    func repositoryUpdateFinished(type: RepositoryType)
}
