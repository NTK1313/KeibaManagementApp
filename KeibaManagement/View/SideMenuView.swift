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
                            
                            NavigationLink {
                                ReportView()
                            } label: {
                                Text("収支レポート")
                            }

                            NavigationLink {
                                ExternalLinkView(url: "https://www.jra.go.jp/datafile/seiseki/replay/\(year)/jyusyo.html")
                            } label: {
                                Text("JRA重賞一覧")
                            }

                            NavigationLink {
                                ExternalLinkView(url: "https://www.keiba.go.jp/gradedrace/schedule_\(year).html")
                            } label: {
                                Text("地方重賞一覧")
                            }
                            NavigationLink{
                                OldGradeRaceSearchView()
                            } label: {
                                Text("過去重賞一覧")
                            }
                            // 上寄せ
                            Spacer()
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
}
