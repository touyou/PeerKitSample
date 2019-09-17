//
//  ViewController.swift
//  PeerKitSample
//
//  Created by 藤井陽介 on 2019/09/16.
//  Copyright © 2019 touyou. All rights reserved.
//

import UIKit
import BeerKit

class ViewController: UIViewController {
    @IBOutlet weak var enemyLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!

    var timer: Timer = Timer()
    var isConnected: Bool = false
    var timeCount: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // 接続を確認する部分
        BeerKit.onConnect { [unowned self] (myPeerId, peerId) in
            self.enemyLabel.text = "対戦相手: \(peerId.displayName)"
            self.isConnected = true
        }

        // 相手からなにか送られてきた時の処理
        BeerKit.onEvent("status") { [unowned self] (peerId, data) in
            guard let data = data,
                let status = try? JSONDecoder().decode(StatusEntity.self, from: data) else {
                    return
            }

            // statusによって処理を切り替えている
            switch status.status {
            case .start:
                // startが送られてきた場合ゲームをスタートする
                if !self.timer.isValid {
                    self.timeCount = 0
                    self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
                    self.timer.fire()
                }
            case .end:
                // endが送られてきた場合ゲームを終了する
                if self.timer.isValid {
                    self.timer.invalidate()
                    self.resultLabel.text = "Opponent invalidated: \(status.score ?? 0)"
                }
            }
        }
    }

    // 自分でゲームを開始することができるのは接続中かつゲームが始まっていない時
    @IBAction func touchUpInsideStartButton(_ sender: Any) {
        if isConnected && !self.timer.isValid {
            timeCount = 0
            self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
            self.timer.fire()
            // この下の部分でイベントを送る
            let status = StatusEntity(status: .start, modeNumber: 0, score: nil)
            let data = try! JSONEncoder().encode(status)
            BeerKit.sendEvent("status", data: data)
        }
    }

    // 自分でゲームを終了することができるのは接続中かつゲーム中
    @IBAction func touchUpInsideStopButton(_ sender: Any) {
        if isConnected && self.timer.isValid {
            self.timer.invalidate()
            self.resultLabel.text = "I invalidated"
            // この下の部分でイベントを送る
            let status = StatusEntity(status: .end, modeNumber: 0, score: timeCount)
            let data = try! JSONEncoder().encode(status)
            BeerKit.sendEvent("status", data: data)
        }
    }

    @objc func update() {
        timeCount += 1
        self.countLabel.text = String(timeCount)
    }
}

