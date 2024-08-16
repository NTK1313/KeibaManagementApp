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
    @EnvironmentObject var viewModel: ViewModel
    @State var selectedDate: Date
    @Binding var isRegisterViewDisplay: Bool
    
    @ObservedObject var registerViewInfo = RegisterViewInfo()
    @State private var isToastViewDisplay = false
    
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
        ZStack{
            VStack(spacing: 1){
                DatePicker(
                    "日付",
                    selection: $selectedDate,
                    displayedComponents: [.date]
                ).environment(\.locale, Locale(identifier: "ja_JP"))
                HStack{
                    Text("場名")
                    PickerViewStyle(value:$registerViewInfo.selectedPlace, text: "places", list: Consts.places)
                }
                HStack{
                    Text("クラス")
                    PickerViewStyle(value:$registerViewInfo.selectedClass, text: "classes", list: Consts.classes)
                    Spacer()
                    Text("レース")
                    PickerViewStyle(value:$registerViewInfo.selectedRace, text: "races", list: Consts.races)
                }
                HStack{
                    Button("レース検索") {
                        print("検索情報：\(dateToString(selectedDate)):\(registerViewInfo.selectedPlace):\(registerViewInfo.selectedClass):\(registerViewInfo.selectedRace)")
                        let raceID = commonUtils.getRaceID(targetDate: dateToString(selectedDate),place: registerViewInfo.selectedPlace, race: registerViewInfo.selectedRace)
                        // Realmからデータ取得
                        let results = realm.object(ofType: RaceInfo.self, forPrimaryKey: raceID)
                        if let results {
                            self.registerViewInfo.raceName = String(results.name)
                            self.registerViewInfo.distance = String(results.distance)
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
                    .disabled(registerViewInfo.buttonDisable)
                    .alert("検索結果がありません。",isPresented: $registerViewInfo.showingAlert) {
                        Button("戻る"){}
                    } message: {
                        Text("検索内容を変更してください。\n※検索できるは中央競馬のレースのみです。")
                    }
                    
                    Text("※中央競馬のみ検索可能")
                        .font(.system(size: 15))
                }
                HStack{
                    HStack(spacing:0){
                        Text("レース名")
                        Text("※")
                        .foregroundColor(.red)                    }
                    TextField("日本ダービー", text: self.$registerViewInfo.raceName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(16.0)
                }
                Text("レース名が未入力です")
                    .foregroundColor(.red)
                    .opacity(registerViewInfo.isRaceNameError ? 1 : 0)
                
                HStack{
                    HStack(spacing:0){
                        Text("購入")
                        Text("※")
                            .foregroundColor(.red)
                    }
                    PickerViewStyle(value: $registerViewInfo.selectedType, text: "course", list: Consts.types)
                    TextField("2400", text: self.$registerViewInfo.distance)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                        .padding(16.0)
                        .onSubmit {
                            print("距離は\(registerViewInfo.distance)")
                        }
                    Text("m")
                }
                Text("距離が未入力です")
                    .foregroundColor(.red)
                    .opacity(registerViewInfo.isDistanceError ? 1 : 0)
                HStack{
                    HStack(spacing:0){
                        Text("購入")
                        Text("※")
                            .foregroundColor(.red)
                    }
                    TextField("1", text: self.$registerViewInfo.buyAmount)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                        .padding(16.0)
                    Text("00")
                }
                // エラーメッセージ
                // TODO: フェードイン、フェードアウトで表示させる
                Text("購入金額が未入力です")
                    .foregroundColor(.red)
                    .opacity(registerViewInfo.isBuyAmounterror ? 1 : 0)
                
                HStack{
                    Text("払戻")
                    TextField("1", text: self.$registerViewInfo.getAmount)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                        .padding(16.0)
                    Text("00")
                }
                HStack{
                    Button("登録") {
                        // 登録済みチェックする
                        if getBalanceOfPayment(){
                            registerViewInfo.isRegisted = true
                        } else {
                            // バリデーションチェック
                            if !isValidateCheck() {
                                // 登録処理中のボタン押下を避けるためすべてのボタンを非活性にする
                                registerViewInfo.buttonDisable = true
                                
                                saveBalanceOfPayment()
                                viewModel.isRegisterViewDisplay.toggle()
                                viewModel.raceDay = dateToString(selectedDate)
                                // 登録成功のトースト表示
                                isToastViewDisplay = true
                                // ダイアログを表出し2秒後にカレンダー画面に戻る
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                    isRegisterViewDisplay.toggle()
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
                        }
                    }
                    .alert("同一レースが既に登録されています。",isPresented: $registerViewInfo.isRegisted) {
                        Button("OK"){}
                    } message: {
                        Text("登録する日付、レースを変更してください。\n同一日付、レースに複数データ登録はできません。")
                    }
                    .disabled(registerViewInfo.buttonDisable)
                    
                    Button("戻る") {
                        isRegisterViewDisplay.toggle()
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .disabled(registerViewInfo.buttonDisable)
                }
                Spacer()
            }
            if self.isToastViewDisplay {
                CommonToast(title: "登録完了", isShown: $isToastViewDisplay)
            }
        }
        
    }
    
    // MARK: - Function
    // Date → String変換
    func dateToString(_ date: Date) -> String {
        return date.convertDateToString(format: Consts.DateFormatter.yyyymmdd_hyphen)
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
        info.getAmount = (Int(registerViewInfo.getAmount) ?? 0) * 100
        do {
            try realm.write {
                realm.add(info)
            }
        } catch {
            print("Error saving context: \(error)")
        }
    }
    
    func getBalanceOfPayment() -> Bool {
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
    var date = Date()
    @State var isRegisterViewDisplay = false
    @EnvironmentObject var viewModel : ViewModel
    return RegisterView(selectedDate: date, isRegisterViewDisplay: $isRegisterViewDisplay)
}

