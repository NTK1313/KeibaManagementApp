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
    
    let model = OldGradeRaceSearchModel()

    var body: some View {
        VStack(spacing: 20) {
            Text("地方競馬・中央競馬の過去重賞一覧を検索します。")
                .padding(.top,30)
            
            HStack(spacing: 0) {
                PickerViewStyle(value:$place, text: "placeKbns", list: Consts.placeKbns)
                    .padding(.leading,30)
                
                PickerViewStyle(value:$selectYear, text: "oldFiveYears", list: Consts.lastFiveYears)
            }
            
            NavigationLink {
                ExternalLinkView(url: "\(model.getURL(place: place, year: selectYear))")
            } label: {
                Text("検索")
                    .customButtonLayout()
            }
            Spacer()
        }
        // ナビゲーションバー設定
        .customNavigationBar(title: "過去重賞検索")
    }
}

#Preview {
    OldGradeRaceSearchView()
}
