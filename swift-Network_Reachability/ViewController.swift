//
//  ViewController.swift
//  swift-Network_Reachability
//
//  Created by 秦兴华 on 2016/12/8.
//  Copyright © 2016年 秦兴华. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var flagLabel: UILabel!
    
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
        if r.currentReachabilityStatus == .reachableViaWWAN  {
            view.backgroundColor = UIColor.green
            flagLabel.text = "数据"
        } else if r.currentReachabilityStatus == .reachableViaWiFi  {
            view.backgroundColor = UIColor.orange
            flagLabel.text = "WiFi"
        } else {
            view.backgroundColor = UIColor.red
            flagLabel.text = "无网络"
        }
    }
    // 当我们接收到一个通知时控会执行以下方法：
    func reachabilityDidChange(_ notification: Notification) {
        checkReachability()
    }
    //当然，你可以使用域名地址调用相应的构造器，如下所示：
    var reachability1 = Reachablity(hostName: "www.apple.com")
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        navigationController?.present(UIViewController(), animated: true, completion: nil)
        navigationController?.dismiss(animated: true, completion: nil)
    }
}

