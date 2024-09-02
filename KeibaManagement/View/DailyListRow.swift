//
//  DailyListRow.swift
//  KeibaManagement
//
//  Created by Naoto on 2024/08/14.
//

import SwiftUI
import RealmSwift

struct DailyListRow: View {
    
    // MARK: - Properties
    let detail: BalanceOfPaymentDetail
    @EnvironmentObject var summaryInfo: SummaryInfo
    @Binding var isDetailDisplay: Bool
    
    @State private var showingAlert = false
    @State private var isUpdate = false
    @State private var buyAmount = 0
    @State private var getAmount = 0
    
    let realm = try! Realm()
    let dbManager = DatabaseManager()
    //TODO: スワイプして削除できるようにする
    
    var body: some View {
        VStack{
            HStack {
                Text("\(detail.racePlace)")
                Text("\(detail.raceNumber)")
                Text("\(detail.name)")
                Text("\(detail.type)")
                Text("\(detail.distance)m")
                Spacer()
            }
            HStack{
                VStack{
                    HStack(spacing: 10){
                        Text("購入金額:")
                        if !isUpdate{
                            Text("¥\(detail.buyAmount)")
                                .foregroundColor(.blue)
                        } else {
                            TextField("", value: $buyAmount, format: .number)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.numberPad)
                                .foregroundColor(.blue)
                        }
                        Spacer()
                    }
                    HStack(spacing: 10){
                        Text("払戻金額:")
                        if !isUpdate {
                            Text("¥\(detail.getAmount)")
                                .foregroundColor(.red)
                        } else {
                            TextField("", value: $getAmount, format: .number)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.numberPad)
                                .foregroundColor(.red)
                        }
                        Spacer()
                    }
                }
                // 変更ボタン
                // TODO: 変更ボタン押下したとき、「変更」→「保存」に「削除」→「戻る」に名前変更し、処理も変える
                Button(action: {
                    if self.isUpdate {
                        // 「保存」ボタンの時の処理
                        self.showingAlert = true
                    } else {
                        // 「変更」ボタンの時の処理
                        print("変更ボタンが押下された")
                        isUpdate.toggle()
                        print("isUpdate:\(isUpdate)")
                        buyAmount = detail.buyAmount
                        getAmount = detail.getAmount
                    }
                }, label: {
                    Text(!isUpdate ? "変更" : "保存")
                        .foregroundColor(.blue)
                })
                .buttonStyle(.bordered)
                .tint(.blue)
                // 削除ボタン
                Button(action: {
                    if !self.isUpdate {
                        // 「削除」ボタンの時の処理
                        self.showingAlert = true
                    } else {
                        // 「戻る」ボタンの時の処理
                        buyAmount = detail.buyAmount
                        getAmount = detail.getAmount
                        isUpdate.toggle()
                    }
                }, label: {
                    Text(!isUpdate ? "削除" : "戻る")
                })
                .buttonStyle(.bordered)
                .tint(.gray)
                .alert(!isUpdate ? "以下のデータを削除します" : "変更内容で保存しますか？" ,isPresented: $showingAlert) {
                    Button("OK"){
                        var result = Enums.RealmResultCode.noData.message
                        if !self.isUpdate {
                            result = dbManager.deleteBalanceOfPayment(key: "raceID", value: detail.raceID)
                        } else {
                            // データ更新処理
                            var updateInfo = BalanceOfPaymentDetail()
                            updateInfo.buyAmount = buyAmount
                            updateInfo.getAmount = getAmount
                            result = dbManager.updateBalanceOfPayment(key: "raceID", value: detail.raceID, updateInfo: updateInfo)
                            self.isUpdate.toggle()
                        }
                        switch result {
                        case Enums.RealmResultCode.success.message:
                            print("成功:\(detail.raceDay)")
                            summaryInfo.raceDay = detail.raceDay
                        case Enums.RealmResultCode.failure.message:
                            print("失敗")
                        case Enums.RealmResultCode.noData.message:
                            print("データなし")
                        default:    // 発生しない想定なので処理しない
                            ""
                        }
                    }
                    // キャンセル時は何もしない
                    Button("キャンセル"){}
                } message: {
                    Text(!isUpdate ? 
                         "\(detail.racePlace) \(detail.raceNumber) \(detail.name)\n \(detail.type) \(detail.distance)m" :
                            "\(detail.racePlace) \(detail.raceNumber) \(detail.name)\n \(detail.type) \(detail.distance)m \n 購入金額: ¥\(buyAmount) \n 払戻金額: ¥\(getAmount)")
                }
            }
        }
    }
}

#Preview {
    var detail = BalanceOfPaymentDetail()
    detail.racePlace = "東京"
    detail.raceClass = "G3"
    detail.raceNumber = "11R"
    detail.name = "東京スポーツ2歳ステークス"
    detail.type = "芝"
    detail.distance = 2000
    detail.buyAmount = 200
    detail.getAmount = 29000
    let summaryInfo: SummaryInfo = SummaryInfo()
    @State var isDetailDisplay = false
    return DailyListRow(detail: detail, isDetailDisplay: $isDetailDisplay)
}
