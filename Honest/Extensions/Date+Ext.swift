//
//  Date+Ext.swift
//  Honest
//
//  Created by Ryan Schefske on 2/21/20.
//  Copyright © 2020 Ryan Schefske. All rights reserved.
//

import Foundation

extension Date {
    
    func convertToMonthDayYearFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale(identifier: "en_US")
        return dateFormatter.string(from: self)
    }
}
