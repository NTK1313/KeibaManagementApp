//
//  SideMenuView.swift
//  KeibaManagement
//
//  Created by Naoto on 2024/09/02.
//

import Foundation
import SwiftUI

struct SideMenuView: View {
    
    @Binding var isSideMenuViewDisplay: Bool
    @Environment(\.dismiss) var dismiss
    
    @State var shouldNavigate: Bool = false
    @State var selectedDestination: Enums.CurrentView = Enums.CurrentView.topCalender
    
    // 現在Viewを監視
    @EnvironmentObject var currentView: CurrentViewInfo
    
    var body: some View {
        
        let today = Date()
        let year = String(Calendar.current.component(.year, from: today))
        let menuArray: [(String,String,Enums.CurrentView)] = [
            ("レース検索", "magnifyingglass",Enums.CurrentView.search),    // 画像アイコン：magnifyingglass　カラー：.blue
            ("トップ", "calendar", Enums.CurrentView.topCalender),  // 画像アイコン：calendar カラー：
            ("収支レポート", "report", Enums.CurrentView.report),  // report
            ("JRA重賞一覧", "jra", Enums.CurrentView.jraList),
            ("地方重賞一覧", "nar", Enums.CurrentView.localList),
            ("過去重賞一覧", "arrow.counterclockwise", Enums.CurrentView.oldList)
        ]
        ZStack {
            // 背景部分
            GeometryReader { geometry in
                HStack {
                    NavigationStack {
                        VStack {
                            List(menuArray, id: \.0) { menu in
                                HStack {
                                    // TODO: 検索項目ごとに画像変えたい
                                    Image(menu.1)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 25, height: 25)
                                    Button(action: {
                                        checkCurrentView(menu.2)
                                    }, label: {
                                        Text(menu.0)
                                    })
                                    .contentShape(Rectangle())
                                }
                            }
                            // Listの余白をなくして画面の横幅いっぱいに広げる
                            .listStyle(.plain)
                            .frame(maxWidth: .infinity)
                            // 上寄せ
                            Spacer()
                            
                            // NavigationLinkは画面遷移のために使用
                            // TODO: この実装はiOS16以降では非推奨
                            NavigationLink(isActive: $shouldNavigate) {
                                switch selectedDestination {
                                case .topCalender:
                                    TopCalenderView(selectedDate: Date().convertDateToString(format: Consts.DateFormatter.yyyyMMdd))
                                case .search:
                                    // TODO: 遷移画面未作成
                                    SearchRaceView()
                                case .report:
                                    ReportView()
                                case .jraList:
                                    ExternalLinkView(url: "https://www.jra.go.jp/datafile/seiseki/replay/\(year)/jyusyo.html",sourceView: Enums.CurrentView.jraList)
                                case .localList:
                                    ExternalLinkView(url: "https://www.keiba.go.jp/gradedrace/schedule_\(year).html",sourceView: Enums.CurrentView.localList)
                                case .oldList:
                                    OldGradeRaceSearchView()
                                    // サイドメニューには表示されない
                                case .registration:
                                    EmptyView()
                                    // 発生しない遷移先
                                case .none:
                                    EmptyView()
                                }
                            } label: {
                                EmptyView()
                            }
                        }
                    }
                    // サイドメニューは全画面の半分だけ表示する
                    .frame(width: geometry.size.width / 2, height: geometry.size.height)
                    .background(Color(UIColor.white))
                    // falseの時はスマホの横幅分だけX軸をマイナスして非表示（=表示位置を画面外）にする。
                    .offset(x: self.isSideMenuViewDisplay ? 0 : -geometry.size.width)
                    .animation(.easeIn(duration: 0.25),value: isSideMenuViewDisplay)
                    
                    // onTapGestureはListと競合するとListのボタンを押下しても発火しなくなる。
                    // そのため画面を二分割して右半分をタップするとサイドメニューが非表示になるようにする。
                    Color.clear
                        .contentShape(Rectangle())
                        .onTapGesture {
                            self.isSideMenuViewDisplay = false
                        }
                }
            }
            .background(Color.gray.opacity(0.8))
            .opacity(self.isSideMenuViewDisplay ? 1.0 : 0.0)
            .animation(.easeIn(duration: 0.25),value: isSideMenuViewDisplay)
        }
    }
    
    /// 画面遷移
    func checkCurrentView(_ newView: Enums.CurrentView){
        if newView == currentView.currentView {
            // 現在と同じ画面を遷移先に選択したためサイドメニューを閉じるだけ
            self.isSideMenuViewDisplay = false
        } else {
            // 画面遷移
            selectedDestination = newView
            shouldNavigate.toggle()
        }
    }
}
