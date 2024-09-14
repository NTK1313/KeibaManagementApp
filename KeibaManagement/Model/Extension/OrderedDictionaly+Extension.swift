//
//  OrderedDictionaly+Extension.swift
//  KeibaManagement
//
//  Created by Naoto on 2024/09/13.
//

import Foundation
import OrderedCollections

internal extension OrderedDictionary {
    
    /// データ追加
    mutating func update(_ other:OrderedDictionary) {
        for (key,value) in other {
            self.updateValue(value, forKey:key)
        }
    }
}
