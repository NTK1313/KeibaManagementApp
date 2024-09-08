//
//  CommonUtils.swift
//  KeibaManagement
//
//  Created by Naoto on 2024/07/06.
//

import Foundation
import UIKit

class CommonUtils {

    /// レースID取得
    func getRaceID(targetDate: String, place: String, race: String) -> String {
        let editDate = targetDate.replacingOccurrences(of:"-", with:"")
        let racePlace = getRacePlaceEnum(place)
        let race = leftZeroPadding(race.replacingOccurrences(of: "R", with: ""))
        return editDate + racePlace.raceID + race
    }
    
    /// 日付が一桁だった場合に0埋めをする。（1 → 01）
    func leftZeroPadding(_ target: String) -> String {
        var value = target
        if target.count == 1 {
            value = "0\(target)"
        }
        return value
    }
    
    /// nilチェック
    func isNil(_ target: String?) -> Bool {
        if target == nil || target == "" {
            return true
        } else {
            return false
        }
    }
    
    /// 特定の文字だけフォント変更する
    /// - Parameters:
    ///   - text: 対象値
    ///   - index: 1文字目から文字色を変更する文字数
    func changeTextColor(text: String, index: Int) -> NSMutableAttributedString {
        let attributedText = NSMutableAttributedString(string: text)
        attributedText.addAttributes(
            [
                //一部の文字に反映させたい内容
                .foregroundColor: UIColor.blue // テキストカラーを変更
            ],
            // sampleUILabelの0文字目から{index}文字目までに変更内容を反映させる
            range: NSMakeRange(0, index)
        )
        return attributedText
    }
    
    /// Enum（RacePlace）取得
    func getRacePlaceEnum(_ place: String) -> Enums.RacePlace {
        switch place {
        case Consts.RacePlace.JRA.tokyo: return Enums.RacePlace.tokyo
        case Consts.RacePlace.JRA.nakayama: return Enums.RacePlace.nakayama
        case Consts.RacePlace.JRA.kyoto: return Enums.RacePlace.kyoto
        case Consts.RacePlace.JRA.hanshin: return Enums.RacePlace.hanshin
        case Consts.RacePlace.JRA.chukyo: return Enums.RacePlace.chukyo
        case Consts.RacePlace.JRA.kokura: return Enums.RacePlace.kokura
        case Consts.RacePlace.JRA.nigata: return Enums.RacePlace.nigata
        case Consts.RacePlace.JRA.fukushima: return Enums.RacePlace.fukushima
        case Consts.RacePlace.JRA.sapporo: return Enums.RacePlace.sapporo
        case Consts.RacePlace.JRA.hakodate: return Enums.RacePlace.hakodate
        case Consts.RacePlace.Local.obihiro: return Enums.RacePlace.obihiro
        case Consts.RacePlace.Local.morioka: return Enums.RacePlace.morioka
        case Consts.RacePlace.Local.mizusawa: return Enums.RacePlace.mizusawa
        case Consts.RacePlace.Local.urawa: return Enums.RacePlace.urawa
        case Consts.RacePlace.Local.funahashi: return Enums.RacePlace.funahashi
        case Consts.RacePlace.Local.ooi: return Enums.RacePlace.ooi
        case Consts.RacePlace.Local.kawasaki: return Enums.RacePlace.kawasaki
        case Consts.RacePlace.Local.kanawaza: return Enums.RacePlace.kanawaza
        case Consts.RacePlace.Local.kasamatsu: return Enums.RacePlace.kasamatsu
        case Consts.RacePlace.Local.nagoya: return Enums.RacePlace.nagoya
        case Consts.RacePlace.Local.sonoda: return Enums.RacePlace.sonoda
        case Consts.RacePlace.Local.himeji: return Enums.RacePlace.himeji
        case Consts.RacePlace.Local.kochi: return Enums.RacePlace.kochi
        case Consts.RacePlace.Local.saga: return Enums.RacePlace.saga
        default: return Enums.RacePlace.overseas
        }
    }

}
