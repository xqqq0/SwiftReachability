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
    
}
