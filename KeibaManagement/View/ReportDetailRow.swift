//
//  ReportDetailRow.swift
//  KeibaManagement
//
//  Created by Naoto on 2024/09/07.
//

import SwiftUI

struct ReportDetailRow: View {
    
    let yyyymm: String
    let summary: BalanceOfPaymentSummary
    
    
    var body: some View {
        HStack {
            Text("\(yyyymm.substr(1, 4))年\(yyyymm.substr(5, 6))月")
            VStack {
                HStack(spacing: 10) {
                    Text("購入金額：¥")
                    Text("\(summary.buyAmount)")
                    // 行数が2行にならないように自動的に文字サイズ調整
                        .lineLimit(1)
                        .minimumScaleFactor(0.1)
                        .foregroundColor(.blue)
                    Spacer()
                }
                HStack(spacing: 10) {
                    Text("払戻金額：¥")
                    Text("\(summary.getAmount)")
                        .foregroundColor(.red)
                        .lineLimit(1)
                        .minimumScaleFactor(0.1)
                    Spacer()
                }
            }
        }

    }
}

#Preview {
    var summary = BalanceOfPaymentSummary()
    summary.buyAmount = 800
    summary.getAmount = 250000000
    return ReportDetailRow(yyyymm: "202409", summary: summary)
}
