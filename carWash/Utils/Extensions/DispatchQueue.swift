//
//  DispatchQueue.swift
//  carWash
//
//  Created by Juliett Kuroyan on 05.12.2019.
//  Copyright © 2019 VooDooLab. All rights reserved.
//

import Foundation

extension DispatchQueue {

    private static var onceTracker = [String]()

    class func once(token: String, block: () -> ()) {
        objc_sync_enter(self); defer { objc_sync_exit(self) }

        if onceTracker.contains(token) {
            return
        }

        onceTracker.append(token)
        block()
    }
    
    class func removeToken(token: String) {
        for i in 0..<onceTracker.count {
            if onceTracker[i] == token {
                onceTracker.remove(at: i)
            }
        }
    }
}
