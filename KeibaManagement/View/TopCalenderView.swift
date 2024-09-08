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
    @State var isSideMenuViewDisplay = false
    @State var isRegisterViewDisplay = false
    // 複数のView間でデータを共有。ObservableObjectに準拠しているため変更状態を監視しており、変数が変更されるとView再描画する
    @EnvironmentObject var summaryInfo: SummaryInfo
        
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
            ZStack{
                // CalenderViewとTotalViewの隙間を10pxに設定
                VStack(spacing: 10) {
                    
                    // MARK: - CalenderView
                    CalendarView(selectedDate:$selectedDate, isDailyListViewDisplay: $isDailyListViewDisplay, summaryInfo: summaryInfo)
                    // Viewのサイズを設定
                        .frame(width: CGFloat(width), height: CGFloat(height),alignment: .top)
                        .navigationDestination(isPresented: $isRegisterViewDisplay) {
                            RegisterView(selectedDate:selectedDate.convertStringToDate(format: format), isRegisterViewDisplay: $isRegisterViewDisplay)
                        }
                        
                        .toolbar {
                            ToolbarItem(placement: .navigationBarLeading) {
                                Button(action: {
                                    isSideMenuViewDisplay.toggle()
                                }) {
                                    Image(systemName: "line.horizontal.3")  // ハンバーガーメニュー
                                }
                            }
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button(action: {
                                    isRegisterViewDisplay.toggle()
                                }) {
                                    Image(systemName: "plus")
                                }
                            }
                        }

                        // ナビゲーションバー設定
                        .customNavigationBar(title: "TEST")
                    
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
                SideMenuView(isSideMenuViewDisplay: $isSideMenuViewDisplay)
            }
        }
    }
}

//
//#Preview {
//    TopCalenderView(selectedDate: "20240628")
//}
