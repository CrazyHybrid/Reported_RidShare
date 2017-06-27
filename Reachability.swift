//
//  Reachability.swift
//  Swift-Reachability
//
//  Created by Isuru Nanayakkara on 9/2/14.
//  Copyright (c) 2014 Isuru Nanayakkara. All rights reserved.
//

import Foundation
import SystemConfiguration

enum ReachabilityType {
    case WWAN,
    WiFi,
    NotConnected
}

public class Reachability {
    
    
    class func connectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(&zeroAddress, {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        }) else {
            return false
        }
        
        var flags : SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        
        let isReachable = flags.contains(.Reachable)
        let needsConnection = flags.contains(.ConnectionRequired)
        return (isReachable && !needsConnection)
    }
    
    class func isConnectedToNetworkOfType() -> ReachabilityType {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(&zeroAddress, {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        }) else {
            return .NotConnected
        }
        
        var flags : SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return .NotConnected
        }
        
        
        let isReachable = flags.contains(.Reachable)
        let isWWAN = (flags.intersect(.IsWWAN)) != []
        
        if(isReachable && isWWAN){
            return .WWAN
        }
        if(isReachable && !isWWAN){
            return .WiFi
        }
        
        return .NotConnected
    }
    
    
    /**
    :see:       Original post - http://www.chrisdanielson.com/2009/07/22/iphone-network-connectivity-test-example/
    :update:    http://stackoverflow.com/questions/25623272/how-to-use-scnetworkreachability-in-swift
    */


//    class func isConnectedToNetwork() -> Bool {
//
//        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
//        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
//        zeroAddress.sin_family = sa_family_t(AF_INET)
//
//        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
//            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0)).takeRetainedValue()
//        }
//        
//        var flags: SCNetworkReachabilityFlags = []
//        if SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) == 0 {
//            return false
//        }
//        
//        let isReachable = (flags & UInt32(kSCNetworkFlagsReachable)) != 0
//        let needsConnection = (flags & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
//        
//        return (isReachable && !needsConnection) ? true : false
//    }
    
//    class func isConnectedToNetworkOfType() -> ReachabilityType {
//        
//        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
//        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
//        zeroAddress.sin_family = sa_family_t(AF_INET)
//        
//        
//        
//        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
//            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0)).takeRetainedValue()
//        }
//        
//        var flags: SCNetworkReachabilityFlags = []
//        if SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) == 0 {
//            return .NotConnected
//        }
//        
//        let isReachable = (flags & UInt32(kSCNetworkFlagsReachable)) != 0
//        let isWWAN = (flags.intersect(SCNetworkReachabilityFlags.IsWWAN)) != []
//        //let isWifI = (flags & UInt32(kSCNetworkReachabilityFlagsReachable)) != 0
//        
//        if(isReachable && isWWAN){
//            return .WWAN
//        }
//        if(isReachable && !isWWAN){
//            return .WiFi
//        }
//        
//        return .NotConnected
//        //let needsConnection = (flags & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
//        
//        //return (isReachable && !needsConnection) ? true : false
//    }
    
}