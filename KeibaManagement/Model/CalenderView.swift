//
//  CalenderView.swift
//  KeibaManagement
//
//  Created by Naoto on 2024/06/26.
//

import Foundation
import SwiftUI
import UIKit
import RealmSwift

struct CalendarView: UIViewRepresentable {
    // @Binding 親子関係にあるView内のStateプロパティ(状態変数)のデータを共有。
    // StateとBindingを紐付けることでプロパティに参照を渡すという。
    @Binding var selectedDate: String
    @Binding var isDailyListViewDisplay: Bool
    // 複数のプロパティをまとめて管理することができる
    // TODO: プロパティをViewModelにまとめる
    @ObservedObject var viewModel: ViewModel

    let realm = try! Realm()
    let dbManager = DatabaseManager()
    
    func makeCoordinator() -> Coordinator {
        print("makeCoordinator")
        // 該当月取得
        let targetMonth = String(selectedDate.replacingOccurrences(of:"-", with:"").prefix(6))
        let dailyList = dbManager.getBalanceOfPayment(key:"raceID",value:targetMonth)
        viewModel.dailyList = dailyList
        // カレンダーに表示する当月の収支取得
        return Coordinator(parent: self,viewModel: _viewModel)
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
        return view
    }
    
    // Viewが更新される時に実行
    func updateUIView(_ uiView: UIViewType, context: Context) {
        if let raceDay = viewModel.raceDay {
            print("raceDay is not nil. raceDay: \(raceDay)")
            // データ登録・更新・削除があった場合にdailyList更新
            let newInfo = dbManager.getBalanceOfPayment(key: "raceDay", value: raceDay)
            if newInfo.count == 0 {
                viewModel.dailyList.removeValue(forKey: raceDay)
            } else {
                viewModel.dailyList.update(newInfo)
            }
            // DateComponents変換
            let editRaceDay = String(raceDay.replacingOccurrences(of:"-", with:""))
            let dateComponents = DateComponents(year: Int(editRaceDay.substr(1, 4)),month: Int(editRaceDay.substr(5, 6)),day: Int(editRaceDay.substr(7, 8)))
            // 指定日データだけ再度下記メソッドを実行
            // calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents)
            uiView.reloadDecorations(forDateComponents: [dateComponents], animated: true)
            viewModel.raceDay = nil
        } else {
            print("raceDay is nil.")
        }
    }
    
    // MARK: - Coordinator
    class Coordinator: NSObject, UICalendarSelectionSingleDateDelegate, UICalendarViewDelegate {
        let commonUtil = CommonUtils()
        let dbManager = DatabaseManager()
        private let parent: CalendarView
        @ObservedObject var viewModel: ViewModel
        
        init(parent: CalendarView,viewModel: ObservedObject<ViewModel>) {
            self.parent = parent
            self._viewModel = viewModel
        }
        // 日付ボタンを押下した時の処理
        func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
            guard let dateComponents else {return}
            print("dateSelection pressed.")
            
            let commonUtils = CommonUtils()
            let month = commonUtils.leftZeroPadding(String(dateComponents.month!))
            let day = commonUtils.leftZeroPadding(String(dateComponents.day!))
            
            parent.selectedDate = "\(dateComponents.year!)-\(month)-\(day)"
            // false → true
            parent.isDailyListViewDisplay.toggle()
        }
        
        // 日付ごとのカスタマイズ（日付の数分このメソッドが呼び出される）
        func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
            print("decoration")
            let year = dateComponents.year!
            let month = commonUtil.leftZeroPadding(String(dateComponents.month!))
            let day = commonUtil.leftZeroPadding(String(dateComponents.day!))
            let date = "\(year)-\(month)-\(day)"
            if let daily = viewModel.dailyList[date] {
                let label = UILabel()
                label.numberOfLines = 2
                label.font = UIFont.systemFont(ofSize: 9)
                label.text = "\(daily.buyAmount)\n\(daily.getAmount)"
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

            let year = previousDateComponents.year!
            let month = previousDateComponents.month!
            print("year:\(year),month:\(month)")
            let cal = Calendar.current
            let comp = DateComponents(year: year, month: month, day: 0)
            let dateString = cal.date(from: comp)!.convertDateToString(format: Consts.DateFormatter.yyyyMM)
            // 結果表示
            let targetMonth = "\(String(dateString.prefix(4)))\(String(dateString.suffix(2)))"
            viewModel.dailyList.update(dbManager.getBalanceOfPayment(key: "raceID", value: targetMonth))
        }

    }
}




