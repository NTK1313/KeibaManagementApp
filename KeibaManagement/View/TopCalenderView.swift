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
    @EnvironmentObject var viewModel: ViewModel
    
    let format = Consts.DateFormatter.yyyymmdd_hyphen
    
    var body: some View {
        NavigationStack{
            NavigationView {
                CalendarView(selectedDate:$selectedDate, isDailyListViewDisplay: $isDailyListViewDisplay, viewModel: viewModel)
                    .padding()
                    .navigationDestination(isPresented: $isDailyListViewDisplay) {
                        DailyListView(
                            isDailyListViewDisplay: $isDailyListViewDisplay,
                            date: selectedDate,
                            buyAmount: viewModel.dailyList[selectedDate]?.buyAmount,
                            getAmount: viewModel.dailyList[selectedDate]?.getAmount)
                    }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isRegisterViewDisplay.toggle()
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .fullScreenCover(isPresented: $isRegisterViewDisplay, content: {
                RegisterView(selectedDate:selectedDate.convertStringToDate(format: format), isRegisterViewDisplay: $isRegisterViewDisplay)
            })
        }
    }
}

#Preview {
    TopCalenderView(selectedDate: "2024/6/28")
}
