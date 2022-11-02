//
//  Reachability.swift
//  HopeRun
//
//  Created by Mukesh Verma on 19/02/17.
//  Copyright © 2017 Mukesh Verma. All rights reserved.
//

import UIKit
import CoreTelephony

import SystemConfiguration

public class Reachability {
    
    class func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        /* Only Working for WIFI
         let isReachable = flags == .reachable
         let needsConnection = flags == .connectionRequired
         
         return isReachable && !needsConnection
         */
        
        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)
        
//        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
//        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
//        let ret = (isReachable && !needsConnection)
//        let netInfo = CTTelephonyNetworkInfo()
//        if let cRAT = netInfo.currentRadioAccessTechnology  {
//            switch cRAT {
//            case CTRadioAccessTechnologyGPRS,
//                 CTRadioAccessTechnologyEdge,
//                 CTRadioAccessTechnologyCDMA1x:
//                print("Reachable Via 2G")
//            case CTRadioAccessTechnologyWCDMA,
//                 CTRadioAccessTechnologyHSDPA,
//                 CTRadioAccessTechnologyHSUPA,
//                 CTRadioAccessTechnologyCDMAEVDORev0,
//                 CTRadioAccessTechnologyCDMAEVDORevA,
//                 CTRadioAccessTechnologyCDMAEVDORevB,
//                 CTRadioAccessTechnologyeHRPD:
//                print("Reachable Via 3G")
//            case CTRadioAccessTechnologyLTE:
//                print("Reachable Via 4G")
//            default:
//                fatalError("error")
//            }
//        }
        
        return ret
        
    }
}
