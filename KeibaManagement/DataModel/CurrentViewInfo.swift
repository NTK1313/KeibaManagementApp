//
//  CurrentViewInfo.swift
//  KeibaManagement
//
//  Created by Naoto on 2024/09/23.
//

import Foundation

class CurrentViewInfo: ObservableObject {
    @Published var currentView: Enums.CurrentView?
    
    func updateCurrentView(to newCurrentView: Enums.CurrentView) {
        currentView = newCurrentView
    }
}
