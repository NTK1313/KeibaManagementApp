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
    @EnvironmentObject var viewModel: ViewModel
    @Binding var isDetailDisplay: Bool

    @State private var showingAlert = false

    let realm = try! Realm()
    let dbManager = DatabaseManager()

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
                        Text("¥\(detail.buyAmount)")
                            .foregroundColor(.blue)
                        Spacer()
                    }
                    HStack(spacing: 10){
                        Text("払戻金額:")
                        Text("¥\(detail.getAmount)")
                            .foregroundColor(.red)
                        Spacer()
                    }
                }
                // 変更ボタン
                Button(action: {
                    // TODO: 変更処理作成
                    print("button pressed.")
                }, label: {
                    Text("変更")
                        .foregroundColor(.blue)
                })
                .buttonStyle(.bordered)
                .tint(.blue)
                // 削除ボタン
                Button(action: {
                    print("button pressed.")
                    self.showingAlert = true
                }, label: {
                    Text("削除")
                })
                .buttonStyle(.bordered)
                .tint(.gray)
                // TODO: 削除処理後はトースト表示してカレンダー画面に再度戻る
                // TODO: カレンダー画面に戻った後はRealmDBから最新データを取得して一覧に反映させる。
                .alert("以下のデータを削除します",isPresented: $showingAlert) {
                    Button("OK"){
                        let result = dbManager.deleteBalanceOfPayment(key: "raceID", value: detail.raceID)
                        switch result {
                        case Enums.RealmResultCode.success.message:
                            print("成功:\(detail.raceDay)")
                            viewModel.raceDay = detail.raceDay
                            // TODO: データ削除後、カレンダー画面まで戻らなくて良い場合は下記処理を削除する
                            // TODO: その場合、戻るボタンを押した時に再度RealmDBから最新のデータをとってきて画面表示させるように修正する。
                            // TODO: 削除更新した時にその目印となるフラグを持たせるか
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
//                                isDetailDisplay.toggle()
//                            }
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
                    Text("\(detail.racePlace) \(detail.raceNumber) \(detail.name)\n \(detail.type) \(detail.distance)m")
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
    let viewModel: ViewModel = ViewModel()
    @State var isDetailDisplay = false
    return DailyListRow(detail: detail, isDetailDisplay: $isDetailDisplay)
}
