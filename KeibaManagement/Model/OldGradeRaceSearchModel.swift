//
//  OldGradeRaceSearchModel.swift
//  KeibaManagement
//
//  Created by Naoto on 2024/09/07.
//

import Foundation

class OldGradeRaceSearchModel {
    /// 外部URLを取得する
    /// - Parameters:
    ///   - place: JRA・地方のいずれか
    ///   - year: 年（過去5年いずれか）
    ///   - return: URL
    func getURL(place: String, year: String) -> String {
        switch place {
        case "JRA": return "\(Enums.JraLocalListURL.jra.url.replacingOccurrences(of: "{year}", with: year))"
        case "地方": return "\(Enums.JraLocalListURL.local.url.replacingOccurrences(of: "{year}", with: year))"
            // 発生しない
        default: return ""
        }
    }
}
