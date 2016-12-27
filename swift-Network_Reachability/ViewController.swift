//
//  ViewController.swift
//  swift-Network_Reachability
//
//  Created by 秦兴华 on 2016/12/8.
//  Copyright © 2016年 秦兴华. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var reachability: Reachablity? = Reachablity.networkReachabilityForInternetConnection()
    
    // 我们在一个视图控制器viewDidLoad()方法中增加一个观察者来进行reachability通知
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityDidChange(_:)), name: NSNotification.Name(rawValue: kReachabilityDidChangeNotificationName), object: nil)
        
        _ = reachability?.startNotifier()
    }
    
    // 在deinit中我们关闭通知：
    deinit {
        NotificationCenter.default.removeObserver(self)
        reachability?.stopNotifier()
    }
    
    // 我们通过检查reachability 来决定控制器是否显示绿色。
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkReachability()
    }
    
    func checkReachability() {
        guard let r = reachability else { return }
        if r.isReachable  {
            view.backgroundColor = UIColor.green
        } else {
            view.backgroundColor = UIColor.red
        }
    }
    // 当我们接收到一个通知时控会执行以下方法：
    func reachabilityDidChange(_ notification: Notification) {
        checkReachability()
    }
    //当然，你可以使用域名地址调用相应的构造器，如下所示：
    var reachability1 = Reachablity(hostName: "www.apple.com")
}

