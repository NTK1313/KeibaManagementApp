//
//  CalenderView.swift
//  KeibaManagement
//
//  Created by Naoto on 2024/06/26.
//

import Foundation
import SwiftUI
import UIKit

struct CalendarView: UIViewRepresentable {
    // @Binding 親子関係にあるView内のStateプロパティ(状態変数)のデータを共有。
    // StateとBindingを紐付けることでプロパティに参照を渡すという。
    @Binding var selectedDate: String
    @Binding var isDailyListViewDisplay: Bool
    // 複数のプロパティをまとめて管理することができる
    @ObservedObject var summaryInfo: SummaryInfo

    let dbManager = DatabaseManager()
    
    func makeCoordinator() -> Coordinator {
        print("makeCoordinator")
        // 該当月取得
        let targetMonth = String(selectedDate.replacingOccurrences(of:"-", with:"").prefix(6))
        let dailySummaryList = dbManager.getBalanceOfPaymentSummary(key:"raceID",value:targetMonth,term: Enums.Term.daily)
        let monthlySummaryList = dbManager.getBalanceOfPaymentSummary(key:"raceID",value:targetMonth,term: Enums.Term.monthly)

        summaryInfo.dailySummaryList = dailySummaryList
        summaryInfo.monthlySummaryList = monthlySummaryList
        
        // カレンダーに表示する当月の収支取得
        return Coordinator(parent: self,summaryInfo: _summaryInfo)
    }
    
    // viewが生成される時に実行
    func makeUIView(context: Context) -> some UICalendarView {
        print("makeUIView")
        let view = UICalendarView()
        view.locale = Locale(identifier: "ja_JP")
        // カレンダーに日付ごとのカスタマイズ設定（calendarViewメソッド実行）
        view.delegate = context.coordinator
        // 日付選択できるようにする
        let dateSelection = UICalendarSelectionSingleDate(delegate: context.coordinator)
        view.selectionBehavior = dateSelection
        view.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        view.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        return view
    }
    
    // Viewが更新される時に実行
    func updateUIView(_ uiView: UIViewType, context: Context) {
        print("updateUIView")

        // RegisterViewで登録したデータを反映させる
        if let raceDay = summaryInfo.raceDay {
            print("raceDay is not nil. raceDay: \(raceDay)")
            let editRaceDay = String(raceDay.replacingOccurrences(of:"-", with:""))
            // データ登録・更新・削除があった場合にdailyList,monthlyList更新
            let newDailyInfo = dbManager.getBalanceOfPaymentSummary(key: "raceID", value: editRaceDay, term: Enums.Term.daily)
            let targetMonth = editRaceDay.substr(1, 6)
            let newMonthlyInfo = dbManager.getBalanceOfPaymentSummary(key: "raceID", value: targetMonth, term: Enums.Term.monthly)
            if newDailyInfo.count == 0 {
                summaryInfo.dailySummaryList.removeValue(forKey: raceDay)
            } else {
                summaryInfo.dailySummaryList.update(newDailyInfo)
            }
            summaryInfo.monthlySummaryList.update(newMonthlyInfo)

            // DateComponents変換
            let dateComponents = DateComponents(year: Int(editRaceDay.substr(1, 4)),month: Int(editRaceDay.substr(5, 6)),day: Int(editRaceDay.substr(7, 8)))
            // 指定日データだけ再度下記メソッドを実行
            // calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents)
            uiView.reloadDecorations(forDateComponents: [dateComponents], animated: true)
            summaryInfo.raceDay = nil
        }
    }
    
    // MARK: - Coordinator
    class Coordinator: NSObject, UICalendarSelectionSingleDateDelegate, UICalendarViewDelegate {
        
        let commonUtil = CommonUtils()
        let dbManager = DatabaseManager()
        private let parent: CalendarView
        @ObservedObject var summaryInfo: SummaryInfo
        
        init(parent: CalendarView,summaryInfo: ObservedObject<SummaryInfo>) {
            self.parent = parent
            self._summaryInfo = summaryInfo
        }
        // MARK: - 日付ボタンが押下された時に実行されるカスタムメソッド
        // 日付ボタンを押下した時の処理
        func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
            guard let dateComponents else {return}
            print("dateSelection pressed.")
            
            let commonUtils = CommonUtils()
            let month = commonUtils.leftZeroPadding(String(dateComponents.month!))
            let day = commonUtils.leftZeroPadding(String(dateComponents.day!))
            
            let selectedDate = "\(dateComponents.year!)\(month)\(day)"
            parent.selectedDate = selectedDate
            if summaryInfo.dailySummaryList[selectedDate] != nil {
                // false → true
                parent.isDailyListViewDisplay.toggle()
            }
        }
        
        // MARK: - 表示月が変更された時に実行されるカスタムメソッド
        // 日付ごとのカスタマイズ（日付の数分このメソッドが呼び出される）
        func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
            let year = dateComponents.year!
            let month = commonUtil.leftZeroPadding(String(dateComponents.month!))
            let day = commonUtil.leftZeroPadding(String(dateComponents.day!))
            let date = "\(year)\(month)\(day)"
            if let daily = summaryInfo.dailySummaryList[date] {
                let label = UILabel()
                label.numberOfLines = 2
                label.font = UIFont.systemFont(ofSize: 9)
                label.text = "\(daily.buyAmount)\n\(daily.getAmount)"
                // 金額は全て赤文字にした後に購入金額だけ青文字に修正
                label.textColor = UIColor(.red)
                label.attributedText = self.commonUtil.changeTextColor(text: label.text!,index: String(daily.buyAmount).count)
                return .customView{label}
            } else {
                return nil
            }
        }
        
        // 表示するカレンダー月が変更された時に呼び出される
        func calendarView(_ calendarView: UICalendarView,didChangeVisibleDateComponentsFrom previousDateComponents: DateComponents) {
            print("didChangeVisibleDateComponentsFrom")
            // 表示月を取得
            let dateComponents = calendarView.visibleDateComponents
            let cal = Calendar.current
            let dateString = cal.date(from: dateComponents)!.convertDateToString(format: Consts.DateFormatter.yyyyMM)
            
            summaryInfo.displayMonth = cal.date(from: dateComponents)!.convertDateToString(format: Consts.DateFormatter.yyyyMM)
            // 結果表示
            let targetMonth = "\(String(dateString.prefix(4)))\(String(dateString.suffix(2)))"
            summaryInfo.dailySummaryList.update(dbManager.getBalanceOfPaymentSummary(key: "raceID", value: targetMonth, term: Enums.Term.daily))
            summaryInfo.monthlySummaryList.update(dbManager.getBalanceOfPaymentSummary(key: "raceID", value: targetMonth, term: Enums.Term.monthly))
        }

    }
}




