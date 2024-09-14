//
//  GraphData.swift
//  KeibaManagement
//
//  Created by Naoto on 2024/09/13.
//

import Foundation
import SwiftUI

// データモデル(Identifiableに準拠していること)
struct BarData: Identifiable {
    var id: String = UUID().uuidString
    var period: String  // 年・月が入る
    var transactionType: String  // 購入・払戻
    var amount: Int
    var color: Color = .red
}
