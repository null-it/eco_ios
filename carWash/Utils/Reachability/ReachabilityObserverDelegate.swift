//
//  ReachabilityObserverDelegate.swift
//  carWash
//
//  Created by Juliett Kuroyan on 29.01.2020.
//  Copyright © 2020 VooDooLab. All rights reserved.
//


import Foundation
import Reachability

//Reachability
//declare this property where it won't go out of scope relative to your listener
fileprivate var reachability: Reachability!

protocol ReachabilityActionDelegate {
    func reachabilityChanged(_ isReachable: Bool)
}

protocol ReachabilityObserverDelegate: class, ReachabilityActionDelegate {
    func addReachabilityObserver() throws
    func removeReachabilityObserver()
    func isReachable() -> Bool 
}

// Declaring default implementation of adding/removing observer
extension ReachabilityObserverDelegate {
    
    /** Subscribe on reachability changing */
    func addReachabilityObserver() throws {
        reachability = try Reachability()
        
        reachability.whenReachable = { [weak self] reachability in
            self?.reachabilityChanged(true)
        }
        
        reachability.whenUnreachable = { [weak self] reachability in
            self?.reachabilityChanged(false)
        }
        
        try reachability.startNotifier()
    }
    
    func isReachable() -> Bool {
        if let reachability = try? Reachability() {
            return reachability.connection != .unavailable
        }
        return false
    }
    
    /** Unsubscribe */
    func removeReachabilityObserver() {
        reachability.stopNotifier()
        reachability = nil
    }
}
