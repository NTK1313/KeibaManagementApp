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
        
        ZStack {
            // 背景部分
            GeometryReader { geometry in
                HStack{
                    NavigationStack {
                        VStack(spacing: 20) {
                            // TODO: 検索一覧はListにしたい
                            Text("その他検索")
                                .padding(.top,10)
                            
                            Button(action: {
                                print("レース検索押下")
                            }, label: {
                                Text("レース検索")
                            })
                            
                            Button(action: {
                                checkCurrentView(Enums.CurrentView.topCalender)
                            }, label: {
                                Text("トップ")
                            })
                            Button(action: {
                                checkCurrentView(Enums.CurrentView.report)
                            }, label: {
                                Text("収支レポート")
                            })
                            
                            Button(action: {
                                checkCurrentView(Enums.CurrentView.jraList)
                            }, label: {
                                Text("JRA重賞一覧")
                            })
                            Button(action: {
                                checkCurrentView(Enums.CurrentView.localList)
                            }, label: {
                                Text("地方重賞一覧")
                            })
                            Button(action: {
                                checkCurrentView(Enums.CurrentView.oldList)
                            }, label: {
                                Text("過去重賞一覧")
                            })
                            // 上寄せ
                            Spacer()
                            
                            // NavigationLinkは画面遷移のために使用
                            // TODO: この実装はiOS16以降では非推奨
                            NavigationLink(isActive: $shouldNavigate) {
                                switch selectedDestination {
                                case .topCalender:
                                    TopCalenderView(selectedDate: Date().convertDateToString(format: Consts.DateFormatter.yyyyMMdd))
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
                }
                // サイドメニューは全画面の半分だけ表示する
                .frame(width: geometry.size.width / 2, height: geometry.size.height)
                // TODO: サイドメニューの背景色を検討する
                .background(Color(UIColor.systemGray6))
                // falseの時はスマホの横幅分だけX軸をマイナスして非表示（=表示位置を画面外）にする。
                .offset(x: self.isSideMenuViewDisplay ? 0 : -geometry.size.width)
                .animation(.easeIn(duration: 0.25),value: isSideMenuViewDisplay)
            }
            .background(Color.gray.opacity(0.8))
            .opacity(self.isSideMenuViewDisplay ? 1.0 : 0.0)
            .animation(.easeIn(duration: 0.25),value: isSideMenuViewDisplay)
            .onTapGesture {
                self.isSideMenuViewDisplay = false
            }
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
