//
//  Array+.swift
//  Core
//
//  Created by 홍성준 on 2023/06/30.
//

import Foundation

extension Array {
    
    public subscript(safe index: Int) -> Element? {
        return self.indices ~= index ? self[index] : nil
    }
    
}
