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
    
    /// データ更新
    /// - Parameters:
    ///   - key: 検索対象カラム
    ///   - value: 検索対象の値
    ///   - return: 結果メッセージ
    // TODO: @escapingを使ってclosureの形に書き換える
    // TODO: 引数や処理条件を再考する
    func updateBalanceOfPayment(key: String, value: String, updateInfo: BalanceOfPaymentDetail) -> String {
        var resultCode = Enums.RealmResultCode.success.message
        let results = realm.objects(BalanceOfPayment.self).filter("\(key) == '\(value)'")
        if results.count > 0 {
            results.forEach { result in
                do {
                    try realm.write {
                        result.getAmount = updateInfo.getAmount
                        result.buyAmount = updateInfo.buyAmount
                    }
                } catch {
                    print("Error \(error)")
                    resultCode = Enums.RealmResultCode.failure.message
                }
            }
        } else {
            resultCode = Enums.RealmResultCode.noData.message
        }
        return resultCode
    }
    
    /// データ削除
    /// - Parameters:
    ///   - key: 検索対象カラム
    ///   - value: 検索対象の値
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
    
    
    /// 集計した購入金額と払戻金額一覧の取得
    /// - Parameters:
    ///   - key: 検索対象カラム
    ///   - value: 検索対象の値
    ///   - term: 期間
    ///   - sort: ソート順（任意）
    ///   - return: 集計した購入金額と払戻金額のリスト
    func getBalanceOfPaymentSummary(key: String, value: String, term: Enums.Term, sort: String = "") -> [String: BalanceOfPaymentSummary] {
        var summaryList: [String: BalanceOfPaymentSummary] = [:]
        let sortKey = sort == "" ? key: sort
        let results = realm.objects(BalanceOfPayment.self).filter("\(key) LIKE '\(value)*'").sorted(byKeyPath: "\(sortKey)")
        var summary = BalanceOfPaymentSummary()

        // 日次・月次・年次
        var lastTerm = ""
        // 日付ごとに金額合計して配列に格納
        results.forEach { result in
            var nowTerm = result.raceDay
            if term == Enums.Term.monthly {
                nowTerm = result.raceDay.substr(1, 6)
            } else if term == Enums.Term.yearly {
              // 未実装
            }
            
            summary.buyAmount = result.buyAmount
            summary.getAmount = result.getAmount
            if nowTerm == lastTerm {
                // 同一日だった場合は前回要素に対してSUMする
                summaryList[lastTerm]?.buyAmount += result.buyAmount
                summaryList[lastTerm]?.getAmount += result.getAmount
            } else {
                summaryList[nowTerm] = summary
                lastTerm = nowTerm
            }
        }
        return summaryList
    }
    
    /// 検索データの詳細情報を取得
    /// - Parameters:
    ///   - key: 検索対象カラム
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
