//
//  Group.swift
//  Service
//
//  Created by 홍성준 on 2023/07/02.
//

import Foundation

public struct Group {
    
    public let name: String
    public let createdAt: Date
    
    public init(name: String, createdAt: Date) {
        self.name = name
        self.createdAt = createdAt
    }
    
}
