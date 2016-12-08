//
//  Production.swift
//  SolarDB
//
//  Created by Florent THOMAS-MOREL on 11/26/16.
//  Copyright © 2016 Florent THOMAS-MOREL. All rights reserved.
//

import Foundation

class Production: AnyObject{
    
    var date: Date
    var production, total: Double
    
    init(date: Date, production: Double, total: Double) {
        self.date = date
        self.production = production
        self.total = total
    }
    
    func copy() -> Production{
        return Production(date: self.date, production: self.production, total: self.total)
    }
    
    static func parse(json: [String: AnyObject]) -> Production?{
        guard let dateJson = json["date"] as? String else { return .none }
        guard let dateStr = dateJson.components(separatedBy: " ").first else { return .none }
        guard let production = json["production"] as? Double else { return .none }
        guard let total = json["total"] as? Double else { return .none }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        guard let date = dateFormatter.date(from: dateStr)?.midnight() else { return .none }
        
        return Production(date: date, production: production, total: total)
    }
    
    static func parse(array: [[String: AnyObject]]) -> [Production] {
        var result:[Production] = []
        for json in array {
            if let production = Production.parse(json: json) {
                result.append(production)
            }
        }
        return result
    }
    
    static func generateProductionArrayForMonth(from: Date, to: Date, productions: [Production]) -> [Production?] {
        guard productions.count > 0 else { return [] }
        var productions = productions
        productions = productions.sorted(by: { (a, b) -> Bool in
            return a.date > b.date
        })
        var data: [Date:Production] = [:]
        for production in productions{
            data[production.date] = production
        }
        var result: [Production?] = []
        var currentDate = from
        while currentDate <= to {
            if let production = data[currentDate] {
                result.append(production)
            }else{
                result.append(nil)
            }
            currentDate.addTimeInterval(86400)
        }
        return result
    }
    
    static func generateProductionArrayForYear(productions: [[Production]], year: Int) -> [Production?] {
        var result: [Production?] = []
        for month in 0...productions.count-1 {
            if productions[month].count == 0 {
                result.append(nil)
                continue
            }
            
            let dateStr = "\(year)-\(String(format: "%2d", month+1))-01"
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date = dateFormatter.date(from: dateStr)!
            let tmp = Production(date: date, production: 0, total: 0)
            for production in productions[month] {
                tmp.production += production.production
                tmp.total += production.total
            }
            
            tmp.production /= Double(productions[month].count)
            tmp.total /= Double(productions[month].count)
            result.append(tmp)
        }
        return result
    }
    
    static func generateProductionFunctionOfCriteria(crtieria:((Weather) -> Double), weathers:[Weather], productions: [Production]) -> [Double: Double] {
        var groups: [Double: [Double]] = [:]
        for weather in weathers {
            let key = crtieria(weather)
            if groups[key] == nil{
               groups[key] = []
            }
            let productions = productions.filter({ (production) -> Bool in
                production.date == weather.date
            })
            groups[key]!.append(contentsOf: productions.map({ (prod) -> Double in
                prod.production
            }))
        }
        
        var result: [Double: Double] = [:]
        
        for (key, values) in groups {
            let val = values.reduce(0, { (result, value) -> Double in
                result + value
            })
            if values.count > 0 {
                result[key] = val/Double(values.count)   
            }
        }
        return result
    }
    
}
