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
    var isConnected: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        //
        BeerKit.onConnect { [unowned self] (myPeerId, peerId) in
            print("接続")
            self.isConnected = true
        }

        BeerKit.onEvent("status") { (peerId, data) in
            guard let data = data,
                let status = try? JSONDecoder().decode(StatusEntity.self, from: data) else {
                    return
            }

            
        }
    }


}

