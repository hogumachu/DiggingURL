//
//  GroupRequest.swift
//  Service
//
//  Created by 홍성준 on 2023/07/02.
//

import Foundation

public struct GroupRequest {
    
    public let predicate: NSPredicate?
    
    public init(name: String? = nil) {
        guard let name else {
            self.predicate = nil
            return
        }
        self.predicate = NSPredicate(format: "name == %@", name)
    }
    
}
