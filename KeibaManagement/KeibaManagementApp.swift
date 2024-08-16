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
    
    @StateObject var viewModel = ViewModel()

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            TopCalenderView(selectedDate: Date().convertDateToString(format: Consts.DateFormatter.yyyymmdd_hyphen))
                .environmentObject(viewModel)
        }
        .modelContainer(sharedModelContainer)
    }
}
// MARK: - AppDelegate設定
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

        // この間に AppDelegate.swift の処理を書く。今回は書いてない
        print("AppDelegate start")
        // Reamlの保存先
        print("Realm保存先: \(Realm.Configuration.defaultConfiguration.fileURL!)")
        // Realm設定
        let _ = try! Realm()
        return true
    }
}

