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
    
    @State var isDisplay = false
    @State var selectedYear = Consts.lastFiveYears[0]
    
    var monthlySummaryList:OrderedDictionary<String, BalanceOfPaymentSummary> = [:]

    // 初期化
    init() {
        let reportModel = ReportModel()
        monthlySummaryList = reportModel.getTargetYearData(selectedYear)
    }
    
    var body: some View {
        /**
         デフォルト表示で当年の年間収支＋各月の月間収支表示         
         グラフ表示のボタン押下したら最上部にグラフ表示
         その際に月間収支の表は下部にスライド
         */
        VStack {
            HStack {
                PickerViewStyle(value:$selectedYear, text: "lastFiveYears", list: Consts.lastFiveYears)
                
                Button(action: {
                    print("レポート出力")
                }, label: {
                    Text("検索")
                })
                
                Button(action: {
                    isDisplay.toggle()
                }, label: {
                    Text(isDisplay ? "グラフ非表示" : "グラフ表示")
                })
            }
            if isDisplay {
                ReportGraphView(monthlySummaryList: monthlySummaryList)
            }
            // 各月の収支一覧
            List{
                // 12ヶ月分を表示
                ForEach(0..<12,id: \.self) { i in
                    ReportDetailRow(yyyymm: Array(monthlySummaryList.keys)[i], summary: Array(monthlySummaryList.values)[i])
                }
            }
        }
        .customNavigationBar(title: "レポート収支")
    }
}

#Preview {
    ReportView()
}
