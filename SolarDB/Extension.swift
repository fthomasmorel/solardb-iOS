//
//  Extension.swift
//  SolarDB
//
//  Created by Florent THOMAS-MOREL on 11/19/16.
//  Copyright © 2016 Florent THOMAS-MOREL. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    class func loadFromNibNamed(nibNamed: String, bundle : Bundle? = nil) -> UIView? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiate(withOwner: nil, options: nil)[0] as? UIView
    }
}

extension Date {
    func toString() -> String{
        let calendar = NSCalendar.current
        let components = calendar.dateComponents([.day, .month, .year], from: self)
        let year =  components.year!
        let month = components.month!
        let day = components.day!
        return "\(String(format: "%02d", day))-\(String(format: "%02d", month))-\(year)"
    }
    
    func toNotificationHour() -> Date{
        let dateString = "\(self.toString()) 18:00:00"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        return dateFormatter.date(from: dateString)!
    }
    
    func day() -> String {
        let calendar = NSCalendar.current
        let components = calendar.dateComponents([.day, .month, .year], from: self)
        let day = components.day!
        return "\(String(format: "%02d", day))"
    }
    
    func month() -> String {
        let calendar = NSCalendar.current
        let components = calendar.dateComponents([.day, .month, .year], from: self)
        let month = components.month!
        return "\(String(format: "%02d", month))"
    }
    
    func monthName() -> String {
        let dateFormatter = DateFormatter()
        let months = dateFormatter.monthSymbols
        return (months?[Int(self.month())!-1])!
    }
    
    func year() -> String {
        let calendar = NSCalendar.current
        let components = calendar.dateComponents([.day, .month, .year], from: self)
        let year = components.year!
        return "\(year)"
    }
    
    func midnight() -> Date {
        let calendar = NSCalendar.current
        var components = calendar.dateComponents([.day, .month, .year, .hour, .minute, .second, .timeZone], from: self)
        
        components.hour = 0
        components.minute = 0
        components.second = 0
        components.timeZone = TimeZone(secondsFromGMT: 0)
        let res = calendar.date(from: components)!
        return res
    }
    
    func firstDayOfTheYear() -> Date {
        let dateString = "01-01-\(self.year())"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter.date(from: dateString)!.midnight()
    }
    
    func firstDayOfTheMonth() -> Date {
        let dateString = "01-\(self.month())-\(self.year())"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter.date(from: dateString)!.midnight()
    }
    
    func lastDayOfTheMonth() -> Date {
        var comps = DateComponents()
        comps.month = 1
        comps.day = -1
        return Calendar.current.date(byAdding: comps, to: self.firstDayOfTheMonth())!.midnight()
    }
    
    func lastDayOfTheYear() -> Date {
        var comps = DateComponents()
        comps.year = 1
        comps.day = -1
        return Calendar.current.date(byAdding: comps, to: self.firstDayOfTheYear())!.midnight()
    }
    
    func previousDay() -> Date {
        var comps = DateComponents()
        comps.day = -1
        return Calendar.current.date(byAdding: comps, to: self)!.midnight()
    }
    
    func previousMonth() -> Date {
        var comps = DateComponents()
        comps.month = -1
        return Calendar.current.date(byAdding: comps, to: self.firstDayOfTheMonth())!.midnight()
    }
    
    func previousYear() -> Date {
        var comps = DateComponents()
        comps.year = -1
        return Calendar.current.date(byAdding: comps, to: self.firstDayOfTheYear())!.midnight()
    }
    
    func nextDay(midnight: Bool = true) -> Date {
        var comps = DateComponents()
        comps.day = 1
        if midnight {
            return Calendar.current.date(byAdding: comps, to: self)!.midnight()
        }else{
            return Calendar.current.date(byAdding: comps, to: self)!
        }
    }
    
    func nextMonth() -> Date {
        var comps = DateComponents()
        comps.month = 1
        return Calendar.current.date(byAdding: comps, to: self.firstDayOfTheMonth())!.midnight()
    }
    
    func nextYear() -> Date {
        var comps = DateComponents()
        comps.year = 1
        return Calendar.current.date(byAdding: comps, to: self.firstDayOfTheYear())!.midnight()
    }
    
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}

extension Double {
    func toCelsius() -> Double {
        return 5.0 / 9.0 * (self - 32.0)
    }
}
