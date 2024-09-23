//
//  Enums.swift
//  KeibaManagement
//
//  Created by Naoto on 2024/08/14.
//

import Foundation

class Enums {
    /// 競馬場と競馬場IDの紐付け
    enum RacePlace: String {
        case tokyo,
             nakayama,
             kyoto,
             hanshin,
             chukyo,
             kokura,
             nigata,
             fukushima,
             sapporo,
             hakodate,
             obihiro,
             morioka,
             mizusawa,
             urawa,
             funahashi,
             ooi,
             kawasaki,
             kanawaza,
             kasamatsu,
             nagoya,
             sonoda,
             himeji,
             kochi,
             saga,
             overseas
        
        var raceName: String {
            switch self {
            case .tokyo: return Consts.RacePlace.JRA.tokyo
            case .nakayama: return Consts.RacePlace.JRA.nakayama
            case .kyoto: return Consts.RacePlace.JRA.kyoto
            case .hanshin: return Consts.RacePlace.JRA.hanshin
            case .chukyo: return Consts.RacePlace.JRA.chukyo
            case .kokura: return Consts.RacePlace.JRA.kokura
            case .nigata: return Consts.RacePlace.JRA.nigata
            case .fukushima: return Consts.RacePlace.JRA.fukushima
            case .sapporo: return Consts.RacePlace.JRA.sapporo
            case .hakodate: return Consts.RacePlace.JRA.hakodate
            case .obihiro: return Consts.RacePlace.Local.obihiro
            case .morioka: return Consts.RacePlace.Local.morioka
            case .mizusawa: return Consts.RacePlace.Local.mizusawa
            case .urawa: return Consts.RacePlace.Local.urawa
            case .funahashi: return Consts.RacePlace.Local.funahashi
            case .ooi: return Consts.RacePlace.Local.ooi
            case .kawasaki: return Consts.RacePlace.Local.kawasaki
            case .kanawaza: return Consts.RacePlace.Local.kanawaza
            case .kasamatsu: return Consts.RacePlace.Local.kasamatsu
            case .nagoya: return Consts.RacePlace.Local.nagoya
            case .sonoda: return Consts.RacePlace.Local.sonoda
            case .himeji: return Consts.RacePlace.Local.himeji
            case .kochi: return Consts.RacePlace.Local.kochi
            case .saga: return Consts.RacePlace.Local.saga
            case .overseas: return Consts.RacePlace.overseas
            }
        }
        var raceID: String {
            switch self {
            case .tokyo: return "01"
            case .nakayama: return "02"
            case .kyoto: return "03"
            case .hanshin: return "04"
            case .chukyo: return "05"
            case .kokura: return "06"
            case .nigata: return "07"
            case .fukushima: return "08"
            case .sapporo: return "09"
            case .hakodate: return "10"
            case .obihiro: return "50"
            case .morioka: return "51"
            case .mizusawa: return "52"
            case .urawa: return "53"
            case .funahashi: return "54"
            case .ooi: return "55"
            case .kawasaki: return "56"
            case .kanawaza: return "57"
            case .kasamatsu: return "58"
            case .nagoya: return "59"
            case .sonoda: return "60"
            case .himeji: return "61"
            case .kochi: return "62"
            case .saga: return "63"
            case .overseas: return "99"
            }
        }
        
    }
    
    /// RealmDB結果コード
    enum RealmResultCode: String {
        case success,
             failure,
             noData
        
        var message: String {
            switch self {
            case .success: return "処理成功"
            case .failure: return "処理失敗"
            case .noData: return "対象データ0件"
            }
        }
    }
    
    // 日次・月次・年次の区分
    enum Term {
        case daily,
             monthly,
             yearly
    }
    
    // JRA・地方重賞一覧URL
    enum JraLocalListURL {
        case jra,
             local
        
        var url: String {
            switch self {
            case .jra: return "https://www.jra.go.jp/datafile/seiseki/replay/{year}/jyusyo.html"
            case .local: return "https://www.keiba.go.jp/gradedrace/schedule_{year}.html"
            }
        }
    }
    
    /// 現在表示中のView
    enum CurrentView: String {
        case topCalender,    // トップ画面b
             report,         // 収支レポート
             jraList,        // JRA重賞一覧
             localList,      // 地方競馬重賞一覧
             oldList,        // 過去重賞一覧
             registration,   // 登録画面
             none            // どの画面にも遷移させるための定義（通常利用はしない）
    }
}
