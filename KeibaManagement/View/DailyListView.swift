//
//  DailyInfoView.swift
//  KeibaManagement
//
//  Created by Naoto on 2024/08/13.
//

import SwiftUI

struct DailyListView: View {
    // 対象の日付
//    @ObservedObject var viewModel: ViewModel
    @Binding var isDailyListViewDisplay: Bool
    let date: String
    let buyAmount:Int?
    let getAmount:Int?
    let dbm = DatabaseManager()
    
    // 画面変更が入らないのでStateを設定していても何も起こらない
//    @State var isDailyListViewDisplay1: Bool = false

    var body: some View {
        let detail = dbm.getBalanceOfPaymentDetail(key: "raceDay", value: date, sort: "raceID")
        Group{
            NavigationView {
                VStack{
                    HStack{
                        Text("合計購入金額: ")
                        Text("¥\(amountNilCheck(buyAmount))")
                            .bold()
                            .foregroundColor(.blue)
                    }
                    HStack{
                        Text("合計払戻金額: ")
                        Text("¥\(amountNilCheck(getAmount))")
                            .bold()
                            .foregroundColor(.red)
                    }

                    List{
                        // TODO: ForEachの時にidで一意性を担保する理由を理解する。
                        ForEach(0..<detail.count,id: \.self) { i in
                            DailyListRow(detail: detail[i], isDetailDisplay: $isDailyListViewDisplay)
                        }
                    }
                }
            }
        }.navigationTitle(date)
    }
    
    func amountNilCheck(_ target: Int?) -> Int{
        return target == nil ? 0 : target!
    }
}


#Preview {
    @State var isDailyListViewDisplay = false
    // TODO: プレビュー表示できるようにMockを作成する
    let viewModel: ViewModel = ViewModel()
    return DailyListView(isDailyListViewDisplay: $isDailyListViewDisplay, date: "2024-08-12", buyAmount: 1000, getAmount: 20000)
}
