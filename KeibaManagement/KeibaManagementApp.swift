//
//  KeibaManagementApp.swift
//  KeibaManagement
//
//  Created by Naoto on 2024/06/26.
//

import SwiftUI
import SwiftData
import RealmSwift
import UIKit

@main
struct KeibaManagementApp: SwiftUI.App {
    // AppDelegateの処理を実行する
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @StateObject var summaryInfo = SummaryInfo()
    @StateObject var currentViewInfo = CurrentViewInfo()

    var body: some Scene {
        WindowGroup {
            TopCalenderView(selectedDate: Date().convertDateToString(format: Consts.DateFormatter.yyyyMMdd))
                .environmentObject(summaryInfo)
                .environmentObject(currentViewInfo)
        }
    }
}
// MARK: - AppDelegate設定
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        print("AppDelegate start")
        // Reamlの保存先
        print("Realm保存先: \(Realm.Configuration.defaultConfiguration.fileURL!)")
        // Realm設定
        let realm = try! Realm()
        
        // データ登録チェック
        let results = realm.objects(RaceInfo.self)
        
        // TODO: 検証のために必ずデータ削除→インポートする
//        try! realm.write {
//            realm.delete(results)
//        }
        
        if results.count == 0 {
            // 初期データをRealmにインポート
            print("初期データが登録されていません。")
            importCsvData()
        }
        return true
    }
    
    func importCsvData() {
        print("importCsvData")
        //csvファイルを格納するための配列を作成
        var csvArray:[String] = []
        //csvファイルの読み込み
        let csvBundle = Bundle.main.path(forResource: "raceInfo", ofType: "csv")
        if let safeCsvBundle = csvBundle {
            do {
                print(safeCsvBundle)
                //csvBundleのパスを読み込み、UTF8に文字コード変換して、NSStringに格納
                let tsvData = try String(contentsOfFile: safeCsvBundle,
                                         encoding: String.Encoding.utf8)
                //改行コードが\n一つになるようにします
                var lineChange = tsvData.replacingOccurrences(of: "\r", with: "\n")
                lineChange = lineChange.replacingOccurrences(of: "\n\n", with: "\n")
                //"\n"の改行コードで区切って、配列csvArrayに格納する
                csvArray = lineChange.components(separatedBy: "\n")
                
                var i = 0
                // TODO: 分ける
                for csvStr in csvArray {
                    // 1行目はヘッダ行のためSKIP
                    let splitStr = csvStr.components(separatedBy: ",")
                    if i > 0 && splitStr[0] != "" {
                        let raceInfo = RaceInfo()
                        raceInfo.raceID = splitStr[0]
                        raceInfo.raceDay = splitStr[1]
                        raceInfo.raceClass = splitStr[2]
                        raceInfo.racePlace = splitStr[3]
                        raceInfo.raceNumber = splitStr[4]
                        raceInfo.name = splitStr[5]
                        raceInfo.type = splitStr[6]
                        raceInfo.distance = Int(splitStr[7])!
                        // 保存
                        let realm = try! Realm()
                        do {
                            try realm.write {
                                realm.add(raceInfo)
                            }
                        } catch {
                            print("Import Error:\(error)")
                        }
                    }
                    i += 1
                }
            } catch {
                print("Error:\(error)")
            }
        } else {
            print("ERROR: csv file is nil.")
        }
        
    }
}

