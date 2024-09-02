//
//  TopCalenderView.swift
//  KeibaManagement
//
//  Created by Naoto on 2024/06/26.
//

import SwiftUI

struct TopCalenderView: View {
    // @State 変数の状態を監視。変数が変更されるとViewを再描画する
    @State var selectedDate: String
    @State var isDailyListViewDisplay = false
    @State var isRegisterViewDisplay = false
    // 複数のView間でデータを共有。ObservableObjectに準拠しているため変更状態を監視しており、変数が変更されるとView再描画する
    @EnvironmentObject var summaryInfo: SummaryInfo
    
    // TODO: 左上にハンバーガーメニュー作る
    // 候補：「期間集計」「重賞一覧」「外部リンク」
    // https://www.jra.go.jp/datafile/seiseki/replay/2024/jyusyo.html
    
    let format = Consts.DateFormatter.yyyyMMdd
    var body: some View {
        // スマホ画面の高さ・幅を取得
        let bounds = UIScreen.main.bounds
        let width = Int(bounds.width)
        let height = Int(bounds.height * 7 / 10)
        
        let displayMonth = summaryInfo.displayMonth
        let monthlyBuyAmountSummary = summaryInfo.monthlySummaryList[summaryInfo.displayMonth]?.buyAmount ?? 0
        let monthlyGetAmountSummary = summaryInfo.monthlySummaryList[summaryInfo.displayMonth]?.getAmount ?? 0
        NavigationStack {
            // CalenderViewとTotalViewの隙間を10pxに設定
            VStack(spacing: 10) {
                // MARK: - CalenderView
                CalendarView(selectedDate:$selectedDate, isDailyListViewDisplay: $isDailyListViewDisplay, summaryInfo: summaryInfo)
                // TODO: 枠線は後で消す
//                    .border(Color.red, width: 4)
                // Viewのサイズを設定
                    .frame(width: CGFloat(width), height: CGFloat(height),alignment: .top)
                //                    .padding(.top,-80)
                    .navigationDestination(isPresented: $isRegisterViewDisplay) {
                        RegisterView(selectedDate:selectedDate.convertStringToDate(format: format), isRegisterViewDisplay: $isRegisterViewDisplay)
                    }
                // TODO: タイトルと背景色は検討する
                    .navigationTitle("テスト")
                // 背景色は常時見える状態にしておく
                    .toolbarBackground(.orange, for: .navigationBar)
                    .toolbarBackground(.visible, for: .navigationBar)
                    .toolbarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: {
                                isRegisterViewDisplay.toggle()
                            }) {
                                Image(systemName: "plus")
                            }
                        }
                    }
                    .sheet(isPresented: $isDailyListViewDisplay, content: {
                        DailyListView(
                            isDailyListViewDisplay: $isDailyListViewDisplay,
                            date: selectedDate,
                            buyAmount: summaryInfo.dailySummaryList[selectedDate]?.buyAmount,
                            getAmount: summaryInfo.dailySummaryList[selectedDate]?.getAmount)
                        .presentationDetents([.medium,.large])
                    }
                    )
                
                // MARK: - TotalView
                VStack(spacing: 10) {
                    Text("\(displayMonth.substr(1, 4))年\(displayMonth.substr(5, 6))月の集計")
                        .font(.system(size: 20))
                        .bold()
                    HStack(spacing: 10) {
                        Text("購入金額合計：¥")
                            .padding(.leading,CGFloat(width / 4))
                        Text("\(monthlyBuyAmountSummary)")
                            .foregroundColor(.blue)
                        Spacer()
                    }
                    HStack(spacing: 10) {
                        Text("払戻金額合計：¥")
                            .padding(.leading,CGFloat(width / 4))
                        Text("\(monthlyGetAmountSummary)")
                            .foregroundColor(.red)
                        Spacer()
                    }
                }
                
                // NavigationStack内のCalenderViewとTotalViewを上寄せし、navigationTitleとの隙間を埋める
                Spacer()
            }
        }
    }
}

#Preview {
    TopCalenderView(selectedDate: "20240628")
}
