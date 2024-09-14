//
//  ReportModel.swift
//  KeibaManagement
//
//  Created by Naoto on 2024/09/10.
//

import Foundation
import OrderedCollections

class ReportModel {
    
    // 月別データ取得
    func getTargetYearData(_ targetYear: String) -> OrderedDictionary<String, BalanceOfPaymentSummary> {
        let dbManager = DatabaseManager()
        let commonUtils = CommonUtils()
        
        let monthlySummaryList = dbManager.getBalanceOfPaymentSummary(key:"raceID",value:targetYear,term: Enums.Term.monthly, sort: "raceID")
        var newMonthlySummaryList:OrderedDictionary<String, BalanceOfPaymentSummary> = [:]
        // 12ヶ月分データ取得できなかった場合
        if monthlySummaryList.count < 12 {
            // データ保管（12回ループ回す）
            for i in 1..<13 {
                let chk = "\(targetYear)\(commonUtils.leftZeroPadding(String(i)))"
                if !monthlySummaryList.keys.contains(chk) {
                    newMonthlySummaryList.updateValue(BalanceOfPaymentSummary(), forKey: chk)
                } else {
                    let value = monthlySummaryList.filter({$0.key == chk})[0]
                    newMonthlySummaryList.updateValue(value.value, forKey: value.key)
                }
            }
        }
        return newMonthlySummaryList
    }
    // 取得データをグラフ表示のためにカスタマイズ
    func createGraph(summaryList: OrderedDictionary<String, BalanceOfPaymentSummary>, term: Enums.Term) -> [BarData] {
        var dataList: [BarData] = []
        for summary in summaryList {
            var key = summary.key
            switch term {
            case Enums.Term.daily:
                key = String(key.suffix(2))
                checkZeroFirst(param: key){string in key = "\(string)日"}
            case Enums.Term.monthly:
                key = String(key.suffix(2))
                checkZeroFirst(param: key){string in key = "\(string)月"}
            case Enums.Term.yearly:
                key = "\(key.substr(1, 4))年"
            }

            let buyAmount = summary.value.buyAmount * -1
            let getAmount = summary.value.getAmount
            let buyData = BarData(period: key, transactionType:  Consts.TransactionType.buy, amount: buyAmount, color: .red)
            let getData = BarData(period: key, transactionType:  Consts.TransactionType.get, amount: getAmount, color: .blue)
            dataList.append(buyData)
            dataList.append(getData)
        }
        return dataList
    }
    
    // トレイリングクロージャ
    // 先頭文字が0の場合は0を取り除く
    private func checkZeroFirst(param: String, handler: (String) -> Void){
        handler(param.prefix(1) == "0" ? String(param.suffix(1)): param)
    }
    
}
