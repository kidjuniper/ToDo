//
//  Data+DateFormatter.swift
//  ToDo
//
//  Created by Nikita Stepanov on 18.09.2024.
//

import Foundation

extension Date {
    private static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        formatter.locale = Locale(identifier: "en")
        return formatter
    }()
    
    private static let fullDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EE, d MMM"
        formatter.locale = Locale(identifier: "en")
        return formatter
    }()
    
    func formattedEventDate(to endDate: Date) -> String {
        let calendar = Calendar.current
        var timeString = "\(Date.timeFormatter.string(from: self)) - \(Date.timeFormatter.string(from: endDate))"
        if Date.timeFormatter.string(from: self) == "12:00 AM",
           Date.timeFormatter.string(from: endDate) == "11:59 PM" {
            timeString = "All Day"
        }
        
        if calendar.isDateInToday(self) {
            return "Today \(timeString)"
        } else if calendar.isDateInTomorrow(self) {
            return "Tomorrow \(timeString)"
        } else {
            let datePart = Date.fullDateFormatter.string(from: self).lowercased()
            return "\(datePart) \(timeString)"
        }
    }
}

