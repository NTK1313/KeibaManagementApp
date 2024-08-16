//
//  StringExtension.swift
//  KeibaManagement
//
//  Created by Naoto on 2024/08/10.
//

import Foundation

internal extension Date {
    
    /// Date型 → String型変換
    func convertDateToString(format: String) -> String {
        // フォーマット設定
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        // ロケール設定（端末の暦設定に引きづられないようにする）
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        // タイムゾーン設定（端末設定によらず固定にしたい場合）
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        // 変換
        return dateFormatter.string(from: self)
    }
}
