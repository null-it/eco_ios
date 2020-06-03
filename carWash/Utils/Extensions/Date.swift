//
//  File.swift
//  carWash
//
//  Created by Juliett Kuroyan on 27.01.2020.
//  Copyright © 2020 VooDooLab. All rights reserved.
//

import Foundation

extension Date {
    
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    
}

