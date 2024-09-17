//
//  ReportView.swift
//  KeibaManagement
//
//  Created by Naoto on 2024/09/07.
//

import SwiftUI
import OrderedCollections

struct ReportView: View {
    let commonUtils = CommonUtils()
    
    @State var isSearch = false
    @State var isGraphDisplay = false
    @State var selectedYear = Consts.lastFiveYears[0]
    
    @State var monthlySummaryList:OrderedDictionary<String, BalanceOfPaymentSummary> = [:]
    
    var body: some View {
        let reportModel = ReportModel()
        /**
         デフォルト表示で当年の年間収支＋各月の月間収支表示         
         グラフ表示のボタン押下したら最上部にグラフ表示
         その際に月間収支の表は下部にスライド
         */
        VStack {
            HStack {
                PickerViewStyle(value:$selectedYear, text: "lastFiveYears", list: Consts.lastFiveYears)
                Button(action: {
                    monthlySummaryList = reportModel.getTargetYearData(selectedYear)
                    isSearch = true
                    isGraphDisplay = false
                }, label: {
                    Text("検索")
                })

                Spacer()

                Button(action: {
                    isGraphDisplay.toggle()
                }, label: {
                    Text(isGraphDisplay ? "グラフ非表示" : "グラフ表示")
                })
            }
            .padding(EdgeInsets(top: 20, leading: 30, bottom: 20, trailing: 30))
            Spacer()

            if isGraphDisplay {
                ReportGraphView(monthlySummaryList: monthlySummaryList)
            }
            
            if isSearch {
                // 各月の収支一覧
                List{
                    // 12ヶ月分を表示
                    ForEach(0..<12,id: \.self) { i in
                        ReportDetailRow(yyyymm: Array(monthlySummaryList.keys)[i], summary: Array(monthlySummaryList.values)[i])
                    }
                }
            }
        }
        .customNavigationBar(title: "レポート収支")
    }
}

#Preview {
    @State var monthlySummaryList:OrderedDictionary<String, BalanceOfPaymentSummary> = [:]
    var bop = BalanceOfPaymentSummary()
    bop.buyAmount = 200
    bop.getAmount = 200
    monthlySummaryList.updateValue(bop, forKey: "202401")
    monthlySummaryList.updateValue(bop, forKey: "202402")
    monthlySummaryList.updateValue(bop, forKey: "202403")
    monthlySummaryList.updateValue(bop, forKey: "202404")
    monthlySummaryList.updateValue(bop, forKey: "202405")
    monthlySummaryList.updateValue(bop, forKey: "202406")
    monthlySummaryList.updateValue(bop, forKey: "202407")
    monthlySummaryList.updateValue(bop, forKey: "202408")
    monthlySummaryList.updateValue(bop, forKey: "202409")
    monthlySummaryList.updateValue(bop, forKey: "202410")
    monthlySummaryList.updateValue(bop, forKey: "202411")
    monthlySummaryList.updateValue(bop, forKey: "202412")
    return ReportView(monthlySummaryList: monthlySummaryList)
}
