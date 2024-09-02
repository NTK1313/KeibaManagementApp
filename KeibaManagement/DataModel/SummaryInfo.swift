//
//  SummaryInfo.swift
//  KeibaManagement
//
//  Created by Naoto on 2024/08/13.
//

import Foundation

class SummaryInfo: ObservableObject {
    @Published var isRegisterViewDisplay: Bool = false
    @Published var raceDay: String?
    @Published var displayMonth: String
    @Published var dailySummaryList: [String: BalanceOfPaymentSummary] = [:]
    @Published var monthlySummaryList: [String: BalanceOfPaymentSummary] = [:]
    
    init(){
        raceDay = Date().convertDateToString(format: Consts.DateFormatter.yyyyMMdd)
        displayMonth = Date().convertDateToString(format: Consts.DateFormatter.yyyyMM)
    }
}
