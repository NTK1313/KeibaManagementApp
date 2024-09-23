//
//  ExternalLinkView.swift
//  KeibaManagement
//
//  Created by Naoto on 2024/09/07.
//

import SwiftUI
import WebKit

struct ExternalLinkView: View {
    let url: String?
    let sourceView: Enums.CurrentView       // 遷移元画面
    
    // 現在Viewを監視
    @EnvironmentObject var currentView: CurrentViewInfo
    
    var body: some View {
        SideMenuContainer(
            content:WebView(urlString: url)
            // ナビゲーションバー設定
                .customNavigationBar(title: "")
        )
        // サイドメニューから遷移先判断するために現在Viewを登録
        .onAppear {
            currentView.updateCurrentView(to: sourceView)
        }
    }
}

#Preview {
    ExternalLinkView(url: "https://www.keiba.go.jp/gradedrace/schedule_2024.html",sourceView: Enums.CurrentView.localList)
}
