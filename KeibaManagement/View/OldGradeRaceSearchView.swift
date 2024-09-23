//
//  OldGradeRaceSearchView.swift
//  KeibaManagement
//
//  Created by Naoto on 2024/09/07.
//

import SwiftUI

struct OldGradeRaceSearchView: View {
    
    @State var place: String = Consts.placeKbns[0]
    @State var selectYear: String = Consts.lastFiveYears[0]
    
    @State private var toLinkView = false // このフラグで画面遷移を制御
    
    // 現在Viewを監視
    @EnvironmentObject var currentView: CurrentViewInfo
    
    let model = OldGradeRaceSearchModel()
    
    var body: some View {
        SideMenuContainer(
            content:VStack(spacing: 20) {
                Text("地方競馬・中央競馬の過去重賞一覧を検索します。")
                    .padding(.top,30)
                
                HStack(spacing: 0) {
                    PickerViewStyle(value:$place, text: "placeKbns", list: Consts.placeKbns)
                        .padding(EdgeInsets(top: 0, leading: 30, bottom: 0, trailing: 30))
                    
                    PickerViewStyle(value:$selectYear, text: "oldFiveYears", list: Consts.lastFiveYears)
                        .padding(EdgeInsets(top: 0, leading: 30, bottom: 0, trailing: 30))
                }
                
                NavigationLink {
                    // 過去の外部URLに遷移させるため、その後はサイドメニューからどの画面にも遷移できるようにCurrentView.noneを定義する
                    ExternalLinkView(url: "\(model.getURL(place: place, year: selectYear))",sourceView: Enums.CurrentView.none)
                } label: {
                    Text("検索")
                        .customButtonLayout(fontsize: 20)
                }
                Spacer()
            }
            // ナビゲーションバー設定
                .customNavigationBar(title: "過去重賞検索")
        )
        // サイドメニューから遷移先判断するために現在Viewを登録
        .onAppear {
            currentView.updateCurrentView(to: Enums.CurrentView.oldList)
        }
    }
}

#Preview {
    OldGradeRaceSearchView()
}
