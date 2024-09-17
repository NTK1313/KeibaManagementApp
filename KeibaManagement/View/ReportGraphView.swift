//
//  ReportGraphView.swift
//  KeibaManagement
//
//  Created by Naoto on 2024/09/09.
//

import SwiftUI
import Charts
import OrderedCollections

struct ReportGraphView: View {
    
    var monthlySummaryList: OrderedDictionary<String, BalanceOfPaymentSummary>

    var body: some View {
        let reportModel = ReportModel()
        let graphInfo = reportModel.createGraph(summaryList: monthlySummaryList, term: Enums.Term.monthly)
        /// ✅Chart自身にデータ群を渡すパターン
        Chart(graphInfo) { dataRow in
            BarMark(
                x: .value("Name", dataRow.period),
                y: .value("Value", dataRow.amount)
            )
            .foregroundStyle(dataRow.color)
            .position(by: .value("Category", dataRow.transactionType))
            
        }
        .frame(height: 300)
        .background(.gray.opacity(0.1))
    }
}

#Preview {
    var list:OrderedDictionary<String, BalanceOfPaymentSummary> = [:]
    var bop = BalanceOfPaymentSummary()
    bop.buyAmount = 1000
    bop.getAmount = 2000
    list.updateValue(bop, forKey: "202401")
    bop.buyAmount = 4000
    bop.getAmount = 0
    list.updateValue(bop, forKey: "202402")
    list.updateValue(bop, forKey: "202403")
    list.updateValue(bop, forKey: "202404")
    bop.buyAmount = 1000
    bop.getAmount = 25000
    list.updateValue(bop, forKey: "202405")
    list.updateValue(bop, forKey: "202406")
    list.updateValue(bop, forKey: "202407")
    list.updateValue(bop, forKey: "202408")
    bop.buyAmount = 3000
    bop.getAmount = 12000
    list.updateValue(bop, forKey: "202409")
    list.updateValue(bop, forKey: "202410")
    bop.buyAmount = 20000
    bop.getAmount = 12000
    list.updateValue(bop, forKey: "202411")
    list.updateValue(bop, forKey: "202412")
    return ReportGraphView(monthlySummaryList: list)
}
