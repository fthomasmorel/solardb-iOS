//
//  CacheManager.swift
//  SolarDB
//
//  Created by Florent THOMAS-MOREL on 12/4/16.
//  Copyright © 2016 Florent THOMAS-MOREL. All rights reserved.
//

import Foundation

class CacheManager: AnyObject {
    
    var yearlyWeather: [Date: [[Weather]]] = [:]
    var monthlyWeather: [Date: [Weather]] = [:]
    var dailyWeather: [Date: Weather] = [:]
    
    var yearlyProduction: [Date: [[Production]]] = [:]
    var monthlyProduction: [Date: [Production]] = [:]
    var dailyProduction: [Date: Production] = [:]
    
    
    init() {}
    
    func saveWeather(year: Date, weather: [[Weather]]){
        DispatchQueue.main.async {
            self.yearlyWeather[year] = weather
        }
    }
    
    func saveWeather(month: Date, weather: [Weather]){
        DispatchQueue.main.async {
            self.monthlyWeather[month] = weather
        }
    }
    
    func saveWeather(day: Date, weather: Weather){
        DispatchQueue.main.async {
            self.dailyWeather[day] = weather
        }
    }
    
    func weather(year: Date) -> [[Weather]]? {
        return self.yearlyWeather[year]
    }
    
    func weather(month: Date) -> [Weather]? {
        return self.monthlyWeather[month]
    }
    
    func weather(day: Date) -> Weather? {
        return self.dailyWeather[day]
    }

    func saveProduction(year: Date, production: [[Production]]){
        DispatchQueue.main.async {
            self.yearlyProduction[year] = production
        }
    }
    
    func saveProduction(month: Date, production: [Production]){
        DispatchQueue.main.async {
            self.monthlyProduction[month] = production
        }
    }
    
    func saveProduction(day: Date, production: Production){
        DispatchQueue.main.async {
            self.dailyProduction[day] = production
        }
    }
    
    func production(year: Date) -> [[Production]]? {
        return self.yearlyProduction[year]
    }
    
    func production(month: Date) -> [Production]? {
        return self.monthlyProduction[month]
    }
    
    func production(day: Date) -> Production? {
        return self.dailyProduction[day]
    }

}
