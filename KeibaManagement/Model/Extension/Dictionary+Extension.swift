//
//  DictionaryExtension.swift
//  KeibaManagement
//
//  Created by Naoto on 2024/08/10.
//

import Foundation

internal extension Dictionary {
    
    /// データ追加
    mutating func update(_ other:Dictionary) {
        for (key,value) in other {
            self.updateValue(value, forKey:key)
        }
    }
}
