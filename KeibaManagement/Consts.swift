//
//  Consts.swift
//  KeibaManagement
//
//  Created by Naoto on 2024/06/29.
//

import Foundation

struct Consts {
    // staticあり　型プロパティ（利用時にインスタンス生成不要）
    static let places = ["東京","中山","京都","阪神","中京","小倉","新潟","福島","札幌","函館","海外","【地方】帯広"
     ,"【地方】門別","【地方】盛岡","【地方】水沢","【地方】浦和","【地方】船橋","【地方】大井","【地方】川崎","【地方】金沢","【地方】笠松","【地方】名古屋","【地方】園田","【地方】姫路","【地方】高知","【地方】佐賀"]
    static let classes = ["GⅠ","GⅡ","GⅢ","リステッド","オープン特別","3勝","2勝","1勝","未勝利","新馬","Jpn GⅠ","Jpn GⅡ","Jpn GⅢ"]
    static let races = ["1R","2R","3R","4R","5R","6R","7R","8R","9R","10R","11R","12R"]
    static let types = ["芝","ダート","障害"]
    
    struct DateFormatter {
        static let yyyyMM = "yyyyMM"
        static let yyyymmdd_hyphen = "yyyy-MM-dd"
        static let yyyymmddhhmiss = "yyyyMMddHHmiss"
    }
    
    struct RacePlace {
        struct JRA {
            static let tokyo = "東京"
            static let nakayama = "中山"
            static let kyoto = "京都"
            static let hanshin = "阪神"
            static let chukyo = "中京"
            static let kokura = "小倉"
            static let nigata = "新潟"
            static let fukushima = "福島"
            static let sapporo = "札幌"
            static let hakodate = "函館"

        }
        struct Local {
            static let obihiro = "【地方】門別"
            static let morioka = "【地方】盛岡"
            static let mizusawa = "【地方】水沢"
            static let urawa = "【地方】浦和"
            static let funahashi = "【地方】船橋"
            static let ooi = "【地方】大井"
            static let kawasaki = "【地方】川崎"
            static let kanawaza = "【地方】金沢"
            static let kasamatsu = "【地方】笠松"
            static let nagoya = "【地方】名古屋"
            static let sonoda = "【地方】園田"
            static let himeji = "【地方】姫路"
            static let kochi = "【地方】高知"
            static let saga = "【地方】佐賀"
        }
        static let overseas = "海外"
    }
}
