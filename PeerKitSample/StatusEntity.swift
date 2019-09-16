//
//  StatusEntity.swift
//  PeerKitSample
//
//  Created by 藤井陽介 on 2019/09/16.
//  Copyright © 2019 touyou. All rights reserved.
//

import Foundation

// このファイルはまるごと真似してしまってオッケー

struct StatusEntity: Codable {
    enum Status: Int, Codable {
        case start
        case end
    }
    // ゲーム開始の合図か、終了の合図か
    let status: Status
    // 何桁のモードで遊んでいるか
    let modeNumber: Int
    // 終了時に勝った方のスコアを送る場合
    let score: Int?
}
