//
//  RegisterViewInfo.swift
//  KeibaManagement
//
//  Created by Naoto on 2024/08/16.
//

import Foundation

class RegisterViewInfo: ObservableObject {
    @Published var raceName:String = ""
    @Published var distance:String = ""
    @Published var buyAmount:String = ""
    @Published var getAmount:String = ""
    
    @Published var selectedPlace:String = Consts.places[0]
    @Published var selectedClass:String = Consts.classes[0]
    @Published var selectedRace:String = Consts.races[0]
    @Published var selectedType:String = Consts.types[0]
    
    @Published var showingAlert = false
    @Published var isRegisted = false
    @Published var buttonDisable = false
    @Published var isRaceNameError = false
    @Published var isDistanceError = false
    @Published var isBuyAmounterror = false
}
