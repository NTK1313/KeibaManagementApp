//
//  ReportView.swift
//  KeibaManagement
//
//  Created by Naoto on 2024/09/07.
//

import SwiftUI

struct ReportView: View {
    let commonUtils = CommonUtils()
    var body: some View {
        /**
         デフォルト表示で当年の年間収支＋各月の月間収支表示         グラフ表示のボタン押下したら最上部にグラフ表示
         その際に月間収支の表は下部にスライド
         */
        VStack {
            HStack {
                Text("2024")

                Button(action: {
                    print("レポート出力")
                }, label: {
                    Text("検索")
                })

                Button(action: {
                    print("グラフ表示")
                }, label: {
                    Text("グラフを表示")
                })
            }
            // 各月の収支一覧
            List{
                // 12ヶ月分を表示
                ForEach(1..<13,id: \.self) { i in
                    ReportDetailRow(yyyymm: "2024年\(commonUtils.leftZeroPadding(String(i)))月")
                }
            }
        }
        
      
            .customNavigationBar(title: "レポート収支")
    }
}

#Preview {
    ReportView()
}
