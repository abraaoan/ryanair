//
//  Utils.swift
//  Ryanair
//
//  Created by Abraao Nascimento on 21/10/21.
//

import UIKit

class Utils: NSObject {
    
    public static func stringfy(_ value: Any) -> String {
        if let v = value as? Int {
            return String(v)
        } else if let v = value as? Float {
            return String(v)
        } else if let v = value as? Double {
            return String(v)
        } else if let v = value as? Data {
            return String(data: v, encoding: .utf8) ?? ""
        } else if let v = value as? [String: Any] {
            var result = ""
            
            for (key, value) in v {
                result += "\(key)=\(stringfy(value))"
            }
            
            return result
        } else if let v = value as? String {
            return v
        } else {
            return ""
        }
    }
    
    public static func getSymbol(forCurrencyCode code: String) -> String? {
        let locale = NSLocale(localeIdentifier: code)
        if locale.displayName(forKey: .currencySymbol, value: code) == code {
            let newlocale = NSLocale(localeIdentifier: code.dropLast() + "_en")
            return newlocale.displayName(forKey: .currencySymbol, value: code)
        }
        return locale.displayName(forKey: .currencySymbol, value: code)
    }
    
    //
    
    public static func getStringDateFormated(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, dd MMM"
        return formatter.string(from: date)
    }
    
    public static func getStringDateFormatedForURL(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
    public static func getDayMonth(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM"
        return formatter.string(from: date)
    }
    
    public static func getWeekName(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: date)
    }
    
    public static func getDateAPIFormat(_ date: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        return formatter.date(from: date) ?? Date()
    }
    
    public static func getDateRequestFormat(_ date: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: date) ?? Date()
    }
    
    public static func dateIsByDays(date: Date, isEqual to:Date) -> Bool {
        let calendar = Calendar.current
        let dayOrder = calendar.compare(date, to: to, toGranularity: .day)
        let monthOrder = calendar.compare(date, to: to, toGranularity: .month)
        return dayOrder == .orderedSame && monthOrder == .orderedSame
    }
    
    public static func getTimeFromDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}
