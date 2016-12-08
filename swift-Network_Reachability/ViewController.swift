//
//  ViewController.swift
//  swift-Network_Reachability
//
//  Created by 秦兴华 on 2016/12/8.
//  Copyright © 2016年 秦兴华. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func test() {
               
        // 类方法初始化 Reachablity 类
        static func networkReachabilityForInternetConnection() -> Reachablity? {
            var zeroAddress = sockaddr_in()
            zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
            zeroAddress.sin_family = sa_family_t(AF_INET)
            return Reachablity(hostAddress: zeroAddress)
        }
        
        // 用来检测当我们是否连接的是本地wifi
        static func networkReachabilityForLocalWiFi() -> Reachablity? {
            var localWifiAddress = sockaddr_in()
            localWifiAddress.sin_len = UInt8(MemoryLayout.size(ofValue: localWifiAddress))
            localWifiAddress.sin_family = sa_family_t(AF_INET)
            // IN_LINKLOCALNETNUM is defined inas 169.254.0.0 (0xA9FE0000).
            localWifiAddress.sin_addr.s_addr = 0xA9FE0000
            
            return Reachablity(hostAddress: localWifiAddress)
        }

    }
}

