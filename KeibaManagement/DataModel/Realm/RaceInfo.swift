//
//  RaceInfo.swift
//  KeibaManagement
//
//  Created by Naoto on 2024/06/30.
//

import Foundation
import RealmSwift

class RaceInfo: Object {
    // 主キー 日付+場所IDレース(202405310101)
    @objc dynamic var raceID: String = ""
    @objc dynamic var raceDay: String = ""
    @objc dynamic var raceClass: String = ""
    @objc dynamic var racePlace: String = ""
    @objc dynamic var raceNumber: String = ""
    // TODO: レース検索表示用レース名　追加するか検討
    // TODO: 発送時刻　追加するか検討
    @objc dynamic var name: String = ""
    @objc dynamic var type: String = ""
    @objc dynamic var distance: Int = 2000
    
    //Primary Keyの設定
     override static func primaryKey() -> String? {
         return "raceID"
     }
}
