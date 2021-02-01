//
//  DateFormatter.swift
//  carWash
//
//  Created by Juliett Kuroyan on 31.01.2020.
//  Copyright © 2020 VooDooLab. All rights reserved.
//

import Foundation


extension DateFormatter {
    
    func string(dateString: String,
                fromFormat: String,
                toHourFormat: String?) -> String {
        locale = Locale(identifier: "ru_RU")
        dateFormat = fromFormat
        guard let date = self.date(from: dateString) else { return "" }
        
        dateStyle = .long
        doesRelativeDateFormatting = true
        var dateDay = string(from: date)
        
        let decimalCharacters = CharacterSet.decimalDigits
        let decimalRange = dateDay.rangeOfCharacter(from: decimalCharacters)
        if decimalRange != nil {
            dateDay.removeLast(" xxxx x.".count)
        }
        
        var formattedDate = "\(dateDay)"

        if let toHourFormat = toHourFormat {
            doesRelativeDateFormatting = false
            dateFormat = toHourFormat
            let dateTime = string(from: date)
            formattedDate += " в \(dateTime)"
        }
        
        return formattedDate
    }
    
}
