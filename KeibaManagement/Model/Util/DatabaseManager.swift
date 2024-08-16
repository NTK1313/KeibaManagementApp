//
//  DatabaseManager.swift
//  KeibaManagement
//
//  Created by Naoto on 2024/08/10.
//

import Foundation
import RealmSwift

class DatabaseManager {
    
    let realm = try! Realm()
    
    /// データ削除
    /// - Parameters:
    ///   - key: 削除対象カラム
    ///   - value: 削除対象の値
    ///   - return: 結果メッセージ
    // TODO: @escapingを使ってclosureの形に書き換える
    func deleteBalanceOfPayment(key: String, value: String) -> String {
        var resultCode = Enums.RealmResultCode.success.message
        let results = realm.objects(BalanceOfPayment.self).filter("\(key) == '\(value)'")
        if results.count > 0 {
            do {
                try realm.write {
                    realm.delete(results)
                }
            } catch {
                print("Error \(error)")
                resultCode = Enums.RealmResultCode.failure.message
            }
        } else {
            resultCode = Enums.RealmResultCode.noData.message
        }
        return resultCode
    }
    
    
    /// 日時集計した購入金額と払戻金額一覧の取得
    /// - Parameters:
    ///   - key: 検索するカラム
    ///   - value: 検索対象の値
    ///   - return: 日時で集計した購入金額と払戻金額のリスト
    func getBalanceOfPayment(key: String, value: String, sort: String = "") -> [String: BalanceOfPaymentDaily] {
        var dailyList: [String: BalanceOfPaymentDaily] = [:]
        let sortKey = sort == "" ? key: sort
        let results = realm.objects(BalanceOfPayment.self).filter("\(key) LIKE '\(value)*'").sorted(byKeyPath: "\(sortKey)")
        var daily = BalanceOfPaymentDaily()
        var lastDay = ""
        // 日付ごとに金額合計して配列に格納
        results.forEach { result in
            let nowDay = result.raceDay
            daily.buyAmount = result.buyAmount
            daily.getAmount = result.getAmount
            if nowDay == lastDay {
                // 同一日だった場合は前回要素に対してSUMする
                dailyList[lastDay]?.buyAmount += result.buyAmount
                dailyList[lastDay]?.getAmount += result.getAmount
            } else {
                dailyList[nowDay] = daily
                lastDay = nowDay
            }
        }
        return dailyList
    }
    
    /// 内部DBから対象データ取得
    /// - Parameters:
    ///   - key: 検索するカラム
    ///   - value: 検索対象の値
    func getBalanceOfPaymentDetail(key: String, value: String, sort: String = "") -> [BalanceOfPaymentDetail] {
        var detailList: [BalanceOfPaymentDetail] = []
        var detail = BalanceOfPaymentDetail()
        let sortKey = sort == "" ? key: sort
        let results = realm.objects(BalanceOfPayment.self).filter("\(key) LIKE '\(value)*'").sorted(byKeyPath: "\(sortKey)")
        print("results.count:\(results.count)")
        results.forEach{ result in
            detail.raceID = result.raceID
            detail.raceDay = result.raceDay
            detail.racePlace = result.racePlace
            detail.raceClass = result.raceClass
            detail.raceNumber = result.raceNumber
            detail.name = result.name
            detail.type = result.type
            detail.distance = result.distance
            detail.buyAmount = result.buyAmount
            detail.getAmount = result.getAmount
            detailList.append(detail)
        }
        return detailList
    }
}
