//
//  Weather.swift
//  SolarDB
//
//  Created by Florent THOMAS-MOREL on 11/26/16.
//  Copyright © 2016 Florent THOMAS-MOREL. All rights reserved.
//

import Foundation

class Weather: AnyObject{
    
    var date: Date
    var temperature, humidity, windSpeed, cloudCover, sunshine: Double
    var classe: String
    
    init(date: Date, temperature: Double, humidity: Double, windSpeed: Double, cloudCover:Double, sunshine: Double, classe: String) {
        self.date = date
        self.temperature = temperature.toCelsius()
        self.humidity = humidity
        self.windSpeed = windSpeed
        self.cloudCover = cloudCover
        self.sunshine = sunshine
        self.classe = classe
    }
    
    func copy() -> Weather{
        return Weather(date: self.date, temperature: self.temperature, humidity: self.humidity, windSpeed: self.windSpeed, cloudCover: self.cloudCover, sunshine: self.sunshine, classe: self.classe)
    }
    
    static func parse(json: [String: AnyObject]) -> Weather?{
        guard let dateJson = json["date"] as? String else { return .none }
        guard let dateStr = dateJson.components(separatedBy: " ").first else { return .none }
        guard let temperature = json["temperature"] as? Double else { return .none }
        guard let humidity = json["humidity"] as? Double else { return .none }
        guard let windSpeed = json["windSpeed"] as? Double else { return .none }
        guard let cloudCover = json["cloudCover"] as? Double else { return .none }
        guard let sunshine = json["sunshine"] as? Double else { return .none }
        guard let classe = json["classe"] as? String else { return .none }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let date = dateFormatter.date(from: dateStr)?.midnight() else { return .none }
        
        return Weather(date: date, temperature: temperature, humidity: humidity, windSpeed: windSpeed, cloudCover: cloudCover, sunshine: sunshine, classe: classe)
    }
    
    static func parse(array: [[String: AnyObject]]) -> [Weather] {
        var result:[Weather] = []
        for json in array {
            if let weather = Weather.parse(json: json) {
                result.append(weather)
            }
        }
        return result
    }
    
    static func generateWeatherArrayForMonth(from: Date, to: Date, weathers: [Weather]) -> [Weather?] {
        guard weathers.count > 0 else { return [] }
        var weathers = weathers
        weathers = weathers.sorted(by: { (a, b) -> Bool in
            return a.date > b.date
        })
        var data: [Date:Weather] = [:]
        for weather in weathers{
            data[weather.date] = weather
        }
        var result: [Weather?] = []
        var currentDate = from
        var lastWeather = weathers.first!
        while currentDate <= to {
            currentDate.addTimeInterval(86400)
            if let weather = data[currentDate] {
                result.append(weather)
                lastWeather = weather.copy()
            }else{
                let weather = lastWeather.copy()
                weather.date = currentDate
                result.append(nil)
            }
        }
        return result
    }
    
    static func generateWeatherArrayForYear(weathers: [[Weather]], year: Int) -> [Weather?] {
        var result: [Weather?] = []
        for month in 0...weathers.count-1 {
            if weathers[month].count == 0 {
                result.append(nil)
                continue
            }
            
            let dateStr = "\(year)-\(String(format: "%2d", month+1))-01"
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date = dateFormatter.date(from: dateStr)!
            let tmp = Weather(date: date, temperature: 0, humidity: 0, windSpeed: 0, cloudCover: 0, sunshine: 0, classe: "")
            for weather in weathers[month] {
                tmp.temperature += weather.temperature
                tmp.humidity += weather.humidity
                tmp.windSpeed += weather.windSpeed
                tmp.cloudCover += weather.cloudCover
                tmp.sunshine += weather.sunshine
            }
            tmp.temperature /= Double(weathers[month].count)
            tmp.humidity /= Double(weathers[month].count)
            tmp.windSpeed /= Double(weathers[month].count)
            tmp.cloudCover /= Double(weathers[month].count)
            tmp.sunshine /= Double(weathers[month].count)
            result.append(tmp)
        }
        return result
    }
    
}
