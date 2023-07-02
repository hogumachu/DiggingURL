//
//  LinkRequest.swift
//  Domain
//
//  Created by 홍성준 on 2023/07/02.
//

import Foundation

public struct LinkRequest {
    
    public let predicate: NSPredicate?
    
    public init(name: String? = nil) {
        guard let name else {
            self.predicate = nil
            return
        }
        self.predicate = NSPredicate(format: "name == %@", name)
    }
    
    public init(url: String) {
        self.predicate = NSPredicate(format: "url == %@", url)
    }
    
    public init(groupID: Date) {
        self.predicate = NSPredicate(format: "groupID == %@", groupID as CVarArg)
    }
    
}
