//
//  RegisterView.swift
//  KeibaManagement
//
//  Created by Naoto on 2024/06/28.
//

import SwiftUI
import RealmSwift

struct RegisterView: View {
    // MARK: - Properties
    @EnvironmentObject var summaryInfo: SummaryInfo
    @State var selectedDate: Date
    @Binding var isRegisterViewDisplay: Bool
    
    @ObservedObject var registerViewInfo = RegisterViewInfo()
    @State private var isToastViewDisplay = false
    @State private var buttonDisable = false
    
    // テキストフィールドをタップした時にキーボードを表出
    // TODO: テキストフィールド選択時にキーボードを出す
    @FocusState private var focusedField: Field?
    
    let realm = try! Realm()
    let commonUtils = CommonUtils()
    
    // MARK: - Enum
    enum Field: Hashable {
        case title
        case message
    }
    
    // MARK: - View
    var body: some View {
        Spacer()
        ScrollView {
            ZStack {
                VStack(spacing: 1){
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
                        Spacer()
                        Text("レース")
                        PickerViewStyle(value:$registerViewInfo.selectedRace, text: "races", list: Consts.races)
                    }
                    .padding(EdgeInsets(top: 0, leading: 16, bottom: 8, trailing: 16))
                    
                    HStack{
                        Button("レース検索") {
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
                        }
                        .disabled(buttonDisable)
                        .alert("検索結果がありません。",isPresented: $registerViewInfo.showingAlert) {
                            Button("戻る"){}
                        } message: {
                            Text("検索内容を変更してください。\n※検索できるは中央競馬のレースのみです。")
                        }
                        Text("※中央競馬のみ検索可能")
                            .font(.system(size: 15))
                    }
                    .padding(EdgeInsets(top: 0, leading: 16, bottom: 8, trailing: 16))
                    
                    
                    HStack() {
                        Text("クラス")
                            .padding(EdgeInsets(top: 0, leading: 16, bottom: 16, trailing: 16))
                        PickerViewStyle(value:$registerViewInfo.selectedClass, text: "classes", list: Consts.classes)
                    }
                    
                    HStack {
                        HStack(){
                            Text("レース名")
                            Text("※")
                                .foregroundColor(.red)
                        }
                        TextField("日本ダービー", text: self.$registerViewInfo.raceName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
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
                        // TODO: 戻るボタンを追加するか検討する
                        Button {
                            // バリデーションチェック
                            if !isValidateCheck() {
                                // 登録済みチェック
                                if !checkBalanceOfPayment(){
                                    // 登録処理中のボタン押下を避けるためすべてのボタンを非活性にする
                                    buttonDisable = true
                                    
                                    saveBalanceOfPayment()
                                    summaryInfo.isRegisterViewDisplay.toggle()
                                    summaryInfo.raceDay = dateToString(selectedDate)
                                    // 登録成功のトースト表示
                                    isToastViewDisplay = true
                                    // ダイアログを表出し2秒後にカレンダー画面に戻る
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                        print("buttonDisable:\(buttonDisable)")
                                        isRegisterViewDisplay.toggle()
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
                            // TODO: 枠でボタン囲う（サイズとボタン範囲検討）
                            Text("登録")
                                .fontWeight(.bold)
                                .font(.system(size: 20))
                                // フォントの色
                                .foregroundColor(Color.white)
                                // 幅を画面いっぱい、高さも指定（maxWidthを使っている場合、heightだと指定できない）
                                .frame(maxWidth: .infinity, minHeight: 48)
                                // ボタンの色
                                .background(Color.blue)
                                // 両端にpaddingをかける
                                .padding(.horizontal, 32)
                        }
                        .alert("同一レースが既に登録されています。",isPresented: $registerViewInfo.isRegisted) {
                            Button("OK"){}
                        } message: {
                            Text("登録する日付、レースを変更してください。\n同一日付、レースに複数データ登録はできません。")
                        }
                        .disabled(buttonDisable)
                    }
                }
                if self.isToastViewDisplay {
                    CommonToast(title: "登録完了", isShown: $isToastViewDisplay)
                }
            }
            .toolbarBackground(.orange, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            
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
    @State var isRegisterViewDisplay = false
    //    @EnvironmentObject var summaryInfo : SummaryInfo
    return RegisterView(selectedDate: date, isRegisterViewDisplay: $isRegisterViewDisplay)
}

