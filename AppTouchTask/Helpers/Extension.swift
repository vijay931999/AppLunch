//
//  Extension.swift
//  AppTouchTask
//
//  Created by Tejas Gowda KC on 14/12/22.
//

import Foundation
import UIKit

extension UIView {
    func setCornerRadius(radius: CGFloat, borderColor: UIColor = #colorLiteral(red: 0.5019607843, green: 0.5843137255, blue: 0.7176470588, alpha: 1), borderWidth: CGFloat = 0.0) {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = radius
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = borderWidth
    }
}

extension Date {
    func toString(dateFormat: String, timeZone: TimeZone = .current) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.timeZone = timeZone
        return dateFormatter.string(from: self)
    }
    
    func addYears(n: Int) -> Date {
        let cal = NSCalendar.current
        return cal.date(byAdding: .year, value: n, to: self)!
    }
    
    func isBetween(_ date1: Date, and date2: Date) -> Bool {
        return (min(date1, date2) ... max(date1, date2)) ~= self
    }
    
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth())!
    }
    
    var startOfYear: Date {
        return Calendar.current.date(from: DateComponents(year: Calendar.current.component(.year, from: self), month: 1, day: 1))!
    }
    
    var endOfYear: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: Calendar.current.date(from: DateComponents(year: Calendar.current.component(.year, from: self) + 1, month: 1, day: 1))!)!
    }
    
}

extension String {
    var toDate: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        if let dateFormat = dateFormatter.date(from: self) {
            return dateFormat
        } else {
            return Date()
        }
    }
    
    var toDateMonthYear: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/YYYY"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        if let dateFormat = dateFormatter.date(from: self) {
            return dateFormat
        } else {
            return Date()
        }
    }
}
