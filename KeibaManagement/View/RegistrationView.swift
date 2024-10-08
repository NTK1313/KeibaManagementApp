//
//  RegistrationView.swift
//  KeibaManagement
//
//  Created by Naoto on 2024/06/28.
//

import SwiftUI
import RealmSwift

struct RegistrationView: View {
    // MARK: - Properties
    @EnvironmentObject var summaryInfo: SummaryInfo
    @Environment(\.dismiss) var dismiss
    // 現在Viewを監視
    @EnvironmentObject var currentView: CurrentViewInfo
    
    @State var selectedDate: Date
    
    @ObservedObject var registerViewInfo = RegisterViewInfo()
    @State private var isToastViewDisplay = false
    @State private var buttonDisable = false
    @State private var shouldNavigate = false
    
    let realm = try! Realm()
    let commonUtils = CommonUtils()
    
    // MARK: - Enum
    enum Field: Hashable {
        case title
        case message
    }
    
    // MARK: - View
    var body: some View {
        SideMenuContainer(content:
                            ScrollView {
            ZStack {
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }
                VStack(spacing: 1) {
                    DatePicker (
                        "日付",
                        selection: $selectedDate,
                        displayedComponents: [.date]
                    )
                    .environment(\.locale, Locale(identifier: "ja_JP"))
                    .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                    
                    HStack{
                        Text("場名")
                        PickerViewStyle(value:$registerViewInfo.selectedPlace, text: "places", list: Consts.places)
                        Text("レース")
                        PickerViewStyle(value:$registerViewInfo.selectedRace, text: "races", list: Consts.races)
                    }
                    .padding(EdgeInsets(top: 0, leading: 16, bottom: 24, trailing: 16))
                    
                    HStack{
                        Button {
                            print("検索情報：\(dateToString(selectedDate)):\(registerViewInfo.selectedPlace):\(registerViewInfo.selectedClass):\(registerViewInfo.selectedRace)")
                            let raceID = commonUtils.getRaceID(targetDate: dateToString(selectedDate),place: registerViewInfo.selectedPlace, race: registerViewInfo.selectedRace)
                            // Realmからデータ取得
                            let results = realm.object(ofType: RaceInfo.self, forPrimaryKey: raceID)
                            if let results {
                                self.registerViewInfo.raceName = String(results.name)
                                self.registerViewInfo.distance = String(results.distance)
                                self.registerViewInfo.selectedClass = String(results.raceClass)
                                switch results.type{
                                case "ダート":
                                    self.registerViewInfo.selectedType = Consts.types[1]
                                case "障害":
                                    self.registerViewInfo.selectedType = Consts.types[2]
                                default:
                                    self.registerViewInfo.selectedType = Consts.types[0]
                                }
                            } else {
                                self.registerViewInfo.showingAlert = true
                            }
                        } label: {
                            Text("レース検索")
                                .customButtonLayout(fontsize: 14, isDisabled: buttonDisable)
                        }
                        .disabled(buttonDisable)
                        .alert("検索結果がありません。",isPresented: $registerViewInfo.showingAlert) {
                            Button("戻る"){}
                        } message: {
                            Text("検索内容を変更してください。\n※検索できるは中央競馬のレースのみです。")
                        }
                    }
                    Text("※中央競馬のみ検索可能")
                        .font(.system(size: 15))
                        .padding(EdgeInsets(top: 0, leading: 16, bottom: 8, trailing: 16))
                    
                    
                    HStack() {
                        Text("クラス")
                        PickerViewStyle(value:$registerViewInfo.selectedClass, text: "classes", list: Consts.classes)
                        Spacer()
                    }
                    .padding(EdgeInsets(top: 0, leading: 16, bottom: 16, trailing: 16))
                    
                    HStack {
                        HStack(){
                            Text("レース名")
                            Text("※")
                                .foregroundColor(.red)
                        }
                        TextField("日本ダービー", text: self.$registerViewInfo.raceName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal,18)
                    }
                    .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                    
                    Text("レース名が未入力です")
                        .foregroundColor(.red)
                        .opacity(registerViewInfo.isRaceNameError ? 1 : 0)
                        .padding(EdgeInsets(top: 0, leading: 16, bottom: 8, trailing: 16))
                    
                    HStack {
                        HStack(){
                            Text("距離")
                            Text("※")
                                .foregroundColor(.red)
                        }
                        PickerViewStyle(value: $registerViewInfo.selectedType, text: "course", list: Consts.types)
                        // TODO: 数字チェックする
                        TextField("2400", text: self.$registerViewInfo.distance)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                            .frame(width: 80.0)
                        Text("m")
                    }
                    .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                    
                    Text("距離が未入力です")
                        .foregroundColor(.red)
                        .opacity(registerViewInfo.isDistanceError ? 1 : 0)
                        .padding(EdgeInsets(top: 0, leading: 16, bottom: 8, trailing: 16))
                    
                    HStack{
                        HStack(){
                            Text("購入")
                        }
                        TextField("1", text: self.$registerViewInfo.buyAmount)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                            .frame(width: 80.0)
                        Text("00")
                        Text("※")
                            .foregroundColor(.red)
                        Spacer()
                    }
                    .padding(EdgeInsets(top: 0, leading: 100, bottom: 0, trailing: 0))
                    
                    Text("購入金額が未入力です")
                        .foregroundColor(.red)
                        .opacity(registerViewInfo.isBuyAmounterror ? 1 : 0)
                        .padding(EdgeInsets(top: 0, leading: 16, bottom: 8, trailing: 16))
                    
                    HStack {
                        Text("払戻")
                        TextField("1", text: self.$registerViewInfo.getAmount)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                            .frame(width: 80.0)
                        Text("0")
                        Spacer()
                    }
                    .padding(EdgeInsets(top: 0, leading: 100, bottom: 16, trailing: 0))
                    
                    HStack{
                        Button {
                            // バリデーションチェック
                            if !isValidateCheck() {
                                // 登録済みチェック
                                if !checkBalanceOfPayment(){
                                    // 登録処理中のボタン押下を避けるためすべてのボタンを非活性にする
                                    buttonDisable = true
                                    
                                    saveBalanceOfPayment()
                                    summaryInfo.raceDay = dateToString(selectedDate)
                                    // 登録成功のトースト表示
                                    isToastViewDisplay = true
                                    // ダイアログを表出し2秒後にカレンダー画面に戻る
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                        // 現在日付に戻す
                                        selectedDate = Date()
                                        // TopViewに遷移する
                                        self.shouldNavigate = true
                                    }
                                } else {
                                    registerViewInfo.isRegisted = true
                                }
                            } else {
                                print("登録エラー")
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                    // 1秒間表示させて非表示に戻す
                                    registerViewInfo.isRaceNameError = false
                                    registerViewInfo.isDistanceError = false
                                    registerViewInfo.isBuyAmounterror = false
                                }
                            }
                            
                        } label: {
                            Text("登録")
                                .customButtonLayout(fontsize:20, isDisabled: buttonDisable)
                        }
                        
                        Button(action: {
                            dismiss()
                        }, label: {
                            Text("戻る")
                            // TODO: カラーは登録と別にするか検討
                                .customButtonLayout(fontsize:20, isDisabled: buttonDisable)
                        })
                        .alert("同一レースが既に登録されています。",isPresented: $registerViewInfo.isRegisted) {
                            Button("OK"){}
                        } message: {
                            Text("登録する日付、レースを変更してください。\n同一日付、レースに複数データ登録はできません。")
                        }
                        .disabled(buttonDisable)
                    }
                }
                // 画面の中心にトースト表示するためVStackの外側に定義
                if self.isToastViewDisplay {
                    CommonToast(title: "登録完了", isShown: $isToastViewDisplay)
                }
            }
            // ナビゲーションバー設定
            .customNavigationBar(title: "登録")
            
        }
        )
        // サイドメニューから遷移先判断するために現在Viewを登録
        .onAppear {
            currentView.updateCurrentView(to: Enums.CurrentView.registration)
        }

        // 登録完了後にTopViewに遷移
        NavigationLink(destination: TopCalenderView(selectedDate: Date().convertDateToString(format: Consts.DateFormatter.yyyyMMdd)), isActive: $shouldNavigate) {
            EmptyView() // 自動遷移のために空のビュー
        }
    }
    
    // MARK: - Function
    // Date → String変換
    func dateToString(_ date: Date) -> String {
        return date.convertDateToString(format: Consts.DateFormatter.yyyyMMdd)
    }
    
    // Realmにデータ登録
    func saveBalanceOfPayment() {
        let info = BalanceOfPayment()
        info.name = registerViewInfo.raceName
        info.raceID = commonUtils.getRaceID(targetDate: dateToString(selectedDate),place: registerViewInfo.selectedPlace, race: registerViewInfo.selectedRace)
        info.raceDay = dateToString(selectedDate)
        info.raceClass = registerViewInfo.selectedClass
        info.racePlace = registerViewInfo.selectedPlace
        info.raceNumber = registerViewInfo.selectedRace
        info.type = registerViewInfo.selectedType
        info.distance = Int(registerViewInfo.distance)!
        info.buyAmount = (Int(registerViewInfo.buyAmount) ?? 0) * 100
        info.getAmount = (Int(registerViewInfo.getAmount) ?? 0) * 10
        do {
            try realm.write {
                realm.add(info)
            }
        } catch {
            print("Error saving context: \(error)")
        }
    }
    
    func checkBalanceOfPayment() -> Bool {
        // Realmからデータ取得
        let raceID = commonUtils.getRaceID(targetDate: dateToString(selectedDate), place: registerViewInfo.selectedPlace, race: registerViewInfo.selectedRace)
        let results = realm.object(ofType: BalanceOfPayment.self, forPrimaryKey: raceID)
        if results != nil {
            return true
        } else {
            return false
        }
    }
    
    func isValidateCheck() -> Bool{
        var isError = false
        if commonUtils.isNil(registerViewInfo.raceName) {
            registerViewInfo.isRaceNameError = true
            isError = true
        }
        if commonUtils.isNil(registerViewInfo.distance) {
            registerViewInfo.isDistanceError = true
            isError = true
        }
        if commonUtils.isNil(registerViewInfo.buyAmount) {
            registerViewInfo.isBuyAmounterror = true
            isError = true
        }
        return isError
    }
}

#Preview {
    let date = Date()
    return RegistrationView(selectedDate: date)
}

