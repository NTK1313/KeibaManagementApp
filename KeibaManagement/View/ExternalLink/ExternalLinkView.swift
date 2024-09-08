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
    
    var body: some View {
        WebView(urlString: url)
        // ナビゲーションバー設定
        .customNavigationBar(title: "")
    }
}

#Preview {
    ExternalLinkView(url: "https://www.keiba.go.jp/gradedrace/schedule_2024.html")
}
