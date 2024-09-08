//
//  ReportDetailRow.swift
//  KeibaManagement
//
//  Created by Naoto on 2024/09/07.
//

import SwiftUI

struct ReportDetailRow: View {
    let yyyymm: String
    
    var body: some View {
        // スマホ画面の高さ・幅を取得
        let bounds = UIScreen.main.bounds
        let width = Int(bounds.width)
        HStack {
            Text("\(yyyymm)")
                
            VStack {
                HStack(spacing: 10) {
                    Text("購入金額：¥")
                    // 行数が2行にならないように自動的に文字サイズ調整
                        .lineLimit(1)
                        .minimumScaleFactor(0.1)
                    Text("10,000,000")
                        .lineLimit(1)
                        .minimumScaleFactor(0.1)
                        .foregroundColor(.blue)
                }
                HStack(spacing: 10) {
                    Text("払戻金額：¥")
                        .lineLimit(1)
                        .minimumScaleFactor(0.1)
                    Text("10,000,000")
                        .foregroundColor(.red)
                        .lineLimit(1)
                        .minimumScaleFactor(0.1)                }
//                .padding(.leading,CGFloat(width / 20))
            }
        }

    }
}

#Preview {
    ReportDetailRow(yyyymm: "2024年06月")
}
