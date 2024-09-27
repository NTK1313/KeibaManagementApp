//
//  View+Extension.swift
//  KeibaManagement
//
//  Created by Naoto on 2024/09/07.
//

import SwiftUI

extension View {
    /// ナビゲーションバーの共通化
    @ViewBuilder
    func customNavigationBar(title: String) -> some View {
        self
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(title)
                        .foregroundColor(Color.white)
                        .font(.system(size: 20))
                        .bold()
                }
            }
        // TODO: 背景色の検討
        // TODO: カラーコードをColor+Extensionに定義する
        // 背景色は常時見える状態にしておく
            .toolbarBackground(Color(UIColor(red: 38/255, green: 131/255, blue: 0/255, alpha: 1.0)), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarTitleDisplayMode(.inline)
        // ハンバーガーメニューに統一するためナビゲーションバーのBackは非表示。
            .navigationBarBackButtonHidden(true)
    }
    
    /// ボタンオブジェクト共通化
    @ViewBuilder
    func customButtonLayout(fontsize: CGFloat, isDisabled: Bool = false) -> some View {
        // TODO: 枠でボタン囲う（サイズとボタン範囲検討）
        self
            .fontWeight(.bold)
            .font(.system(size: fontsize))
        // フォントの色
            .foregroundColor(Color.white)
        // 幅を画面いっぱい、高さも指定（maxWidthを使っている場合、heightだと指定できない）
            .frame(maxWidth: .infinity, minHeight: 20)
        // ボタンの色
            .background(isDisabled ? Color.gray : Color.blue)
        // 両端にpaddingをかける
            .padding(.horizontal, 32)
    }
}
