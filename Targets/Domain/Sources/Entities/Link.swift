//
//  Link.swift
//  Domain
//
//  Created by 홍성준 on 2023/07/02.
//

import Foundation

public struct Link {
    
    public let groupID: Date
    public let name: String
    public let url: String
    public let description: String
    
    public init(groupID: Date, name: String, url: String, description: String) {
        self.groupID = groupID
        self.name = name
        self.url = url
        self.description = description
    }
    
}
