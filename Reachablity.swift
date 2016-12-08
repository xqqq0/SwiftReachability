//
//  Reachablity.swift
//  swift-Network_Reachability
/*
 ********************************************************************* */
 //代码参考自
 //http://www.cocoachina.com/swift/20161124/18129.html

import Foundation
import SystemConfiguration

class Reachablity: NSObject {
    // 网络变化时发出通知的key值
    let kReachabilityDidChangeNotificationName = "ReachabilityDidChangeNotification"
    
    enum ReachabilityStatus {
        case notReachable
        case reachableViaWiFi
        case reachableViaWWAN
    }
    
    // 在这个类中添加一个属性来保存SCNetworkReachability对象：
    private var networkReachability: SCNetworkReachability?
    
    //现在我们需要定定义一个开启通知和一个关闭通知方法，并定义一个属性来标识通知状态当前处于开启状态还是关闭状态：
    private var notifying: Bool = false
    
    
    /*
     为了监控目前服务器是否可以连接，我们创建一个初始化方法,把域名为作参数传入，并通过SCNetworkReachabilityCreateWithName 函数初始化 SCNetworkReachability对象 。如果SCNetworkReachability初始化失败则返回nil，所以我们创建一个可失败初始化方法(failable initializer):
     */
    init?(hostName: String) {
        networkReachability = SCNetworkReachabilityCreateWithName(kCFAllocatorDefault, (hostName as NSString).utf8String!)
        super.init()
        if networkReachability == nil {
            return nil
        }
    }
    
    /*
     为了创建一个根据ip网络地址的reachability对象，我们需要实现另外一个初始化方法。这种情况我们将使用
     SCNetworkReachabilityCreateWithAddress 函数。由于这个函数需要一个指向网络地址的指针，所以我们称它为withUnsafePointer函数。这种情况下，正如我们前面讲到的那样，函数的返回值可能是nil，所以要使init方法可以失败
     */
    init?(hostAddress: sockaddr_in) {
        var address = hostAddress
        guard let defaultRouteReachability = withUnsafePointer(to: &address, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, $0)
            }
        }) else {
            return nil
        }
        networkReachability = defaultRouteReachability
        
        super.init()
        if networkReachability == nil {
            return nil
        }
    }
    
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
    
    // 定义一个开启通知和一个关闭通知方法
    func startNotifier() -> Bool {
        
        //开启通知之前，先检查通知是否为开启状态。
        guard notifying == false else {
            return false
        }
        
        var context = SCNetworkReachabilityContext()
        context.info = UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque())
        let callOut: SCNetworkReachabilityCallBack = { (target: SCNetworkReachability, flags: SCNetworkReachabilityFlags, info: UnsafeMutableRawPointer?) in
            if let currentInfo = info {
                let infoObject = Unmanaged<AnyObject>.fromOpaque(currentInfo).takeUnretainedValue()
                if infoObject is Reachablity {
                    let networkReachability = infoObject as! Reachablity
                    NotificationCenter.default.post(name: Notification.Name(rawValue: infoObject.kReachabilityDidChangeNotificationName), object: networkReachability)
                }
            }
        }
        guard let reachability = networkReachability, SCNetworkReachabilitySetCallback(reachability,callOut, &context) == false else {
            return true
        }
        notifying = true
        return notifying
    }


    
}
