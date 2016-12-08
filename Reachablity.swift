//
//  Reachablity.swift
//  swift-Network_Reachability
/*
 ********************************************************************* */
 //文章转自
 // http://mp.weixin.qq.com/s?__biz=MjM5OTM0MzIwMQ==&mid=2652547965&idx=1&sn=887b834ea194862a45b3e643f09f4254&chksm=bcd2ee738ba56765ecc4f429644cd6a2686a7c3172e6ba30da11fdde5b8cede72c9ec8157dea&mpshare=1&scene=1&srcid=1207yuUxoVJ5ixeCUw2DTAD9#rd.

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


    
}
