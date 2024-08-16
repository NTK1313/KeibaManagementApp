//
//  BalanceOfPayment.swift
//  KeibaManagement
//
//  Created by Naoto on 2024/07/09.
//

import Foundation
import RealmSwift

class BalanceOfPayment: Object {
    // 主キー 日付+場所ID+レース(202405310101)
    @objc dynamic var raceID: String = ""

    // RaceInfoに登録されていない情報を考慮してRaceInfoと同じ情報を持たせる
    @objc dynamic var raceDay: String = ""
    @objc dynamic var raceClass: String = ""
    @objc dynamic var racePlace: String = ""
    @objc dynamic var raceNumber: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var type: String = ""
    @objc dynamic var distance: Int = 2000
    @objc dynamic var buyAmount: Int = 0
    @objc dynamic var getAmount: Int = 0

    //Primary Keyの設定
     override static func primaryKey() -> String? {
         return "raceID"
     }
}
