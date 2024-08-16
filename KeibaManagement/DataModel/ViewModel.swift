//
//  ViewModel.swift
//  KeibaManagement
//
//  Created by Naoto on 2024/08/13.
//

import Foundation

class ViewModel: ObservableObject {
    // TODO: ViewModelのクラス構成検討する
    @Published var isRegisterViewDisplay: Bool = false
    @Published var raceDay: String?
    @Published var dailyList: [String: BalanceOfPaymentDaily] = [:]
}
