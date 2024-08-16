//
//  String+Extenxion.swift
//  KeibaManagement
//
//  Created by Naoto on 2024/08/13.
//

import Foundation

internal extension String {
    
    /// 文字数切り取り
    /// - Parameters:
    ///   - start: 切り取り開始文字（番目）
    ///   - end: 切り取り終了文字（番目）
    func substr(_ start: Int,_ end: Int) -> String {
        // {start}文字目の位置を指定
        let startIndex = self.index(self.startIndex, offsetBy: start - 1)
        // {end}文字目の位置を指定
        // endIndexは末尾+1文字目なので4文字ずらす
        let endIndex = self.index(self.endIndex,offsetBy: (self.count - end + 1) * -1)
        return String(self[startIndex...endIndex])
    }
    
    /// String型 → Date型変換
    func convertStringToDate(format: String) -> Date {
        // フォーマット設定
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = format
        // ロケール設定（端末の暦設定に引きづられないようにする）
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        // タイムゾーン設定（端末設定によらず固定にしたい場合）
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        return dateFormatter.date(from: self)!
    }
}
