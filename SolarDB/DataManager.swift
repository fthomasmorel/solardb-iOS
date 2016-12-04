//
//  DataManager.swift
//  SolarDB
//
//  Created by Florent THOMAS-MOREL on 12/4/16.
//  Copyright © 2016 Florent THOMAS-MOREL. All rights reserved.
//

import Foundation

extension DashboardViewController{
    
    func getDailyData(date: Date){
        self.downloadGroup.enter()
        
        if let data = self.cacheManager.production(day: date){
            if self.currentTimeScale == .day {
                self.currentProduction = data.production
                self.production = data
            }
        }else{
            self.downloadGroup.enter()
            RequestManager.getProductionForDay(date: date) { production in
                if self.currentTimeScale == .day {
                    self.currentProduction = production?.production
                    self.production = production
                }
                if let prod = production {
                    self.cacheManager.saveProduction(day: date, production: prod)
                }
                self.downloadGroup.leave()
            }
        }
        
        if let data = self.cacheManager.production(day: date.previousDay()){
            if self.currentTimeScale == .day {
                self.previousProduction = data.production
            }
        }else{
            self.downloadGroup.enter()
            RequestManager.getProductionForDay(date: date.previousDay()) { production in
                if self.currentTimeScale == .day {
                    self.previousProduction = production?.production
                }
                
                if let prod = production {
                    self.cacheManager.saveProduction(day: date.previousDay(), production: prod)
                }
                self.downloadGroup.leave()
            }
        }
        
        self.downloadGroup.leave()
    }
    
    func getMonthlyData(date: Date){
        self.downloadGroup.enter()
        let dateStart1 = date.firstDayOfTheMonth()
        let dateEnd1 = date.lastDayOfTheMonth()
        
        let dateStart2 = date.previousMonth()
        let dateEnd2 = dateStart2.lastDayOfTheMonth()
        
        if let data = self.cacheManager.weather(month: dateStart1){
            self.monthlyWeather = data
        }else{
            self.downloadGroup.enter()
            RequestManager.getWeatherForMonth(date: dateStart1) { weather in
                self.cacheManager.saveWeather(month: dateStart1, weather: weather)
                self.monthlyWeather = Weather.generateWeatherArrayForMonth(from: dateStart1, to: dateEnd1, weathers: weather)
                self.downloadGroup.leave()
            }
        }
        
        if let data = self.cacheManager.weather(month: dateStart2){
            self.previousMonthlyWeather = data
        }else{
            self.downloadGroup.enter()
            RequestManager.getWeatherForMonth(date: dateStart2) { weather in
                self.cacheManager.saveWeather(month: dateStart2, weather: weather)
                self.previousMonthlyWeather = Weather.generateWeatherArrayForMonth(from: dateStart2, to: dateEnd2, weathers: weather)
                self.downloadGroup.leave()
            }
        }
        
        if let data = self.cacheManager.production(month: dateStart1){
            self.monthlyProduction = Production.generateProductionArrayForMonth(from: dateStart1, to: dateEnd1, productions: data)
            if self.currentTimeScale == .month {
                if let first = data.first{
                    if let last = data.last{
                        self.currentProduction = abs(first.total-last.total)
                    }
                }
            }
        }else{
            self.downloadGroup.enter()
            RequestManager.getProductionForMonth(date: dateStart1) { productions in
                self.cacheManager.saveProduction(month: dateStart1, production: productions)
                self.monthlyProduction = Production.generateProductionArrayForMonth(from: dateStart1, to: dateEnd1, productions: productions)
                if self.currentTimeScale == .month {
                    if let first = productions.first{
                        if let last = productions.last{
                            self.currentProduction = abs(first.total-last.total)
                        }
                    }
                }
                self.downloadGroup.leave()
            }
        }
        
        if let data = self.cacheManager.production(month: dateStart2){
            self.previousMonthlyProduction = Production.generateProductionArrayForMonth(from: dateStart2, to: dateEnd2, productions: data)
            if self.currentTimeScale == .month {
                if let first = data.first{
                    if let last = data.last{
                        self.previousProduction = abs(first.total-last.total)
                    }
                }
            }
        }else{
            self.downloadGroup.enter()
            RequestManager.getProductionForMonth(date: dateStart2) { productions in
                self.cacheManager.saveProduction(month: dateStart2, production: productions)
                self.previousMonthlyProduction = Production.generateProductionArrayForMonth(from: dateStart2, to: dateEnd2, productions: productions)
                if self.currentTimeScale == .month {
                    if let first = productions.first{
                        if let last = productions.last{
                            self.previousProduction = abs(first.total-last.total)
                        }
                    }
                }
                self.downloadGroup.leave()
            }
        }
        self.downloadGroup.leave()
    }
    
    func getYearlyData(date: Date){
        self.downloadGroup.enter()
        let dateStart1 = date.firstDayOfTheYear()
        let dateStart2 = date.previousYear()
        
        if let data = self.cacheManager.production(year: dateStart1){
            self.allProduction = data
            self.yearlyProduction = Production.generateProductionArrayForYear(productions: data, year: Int(dateStart1.year())!)
            let prods = data.filter({ (prods) -> Bool in
                prods.count > 0
            })
            if self.currentTimeScale == .year {
                if let first = prods.first{
                    if let last = prods.last{
                        self.currentProduction = abs(first.first!.total-last.last!.total)
                    }
                }
            }
            
        }else{
            self.downloadGroup.enter()
            RequestManager.getProductionForYear(date: dateStart1) { productions in
                self.allProduction = productions
                self.cacheManager.saveProduction(year: dateStart1, production: productions)
                self.yearlyProduction = Production.generateProductionArrayForYear(productions: productions, year: Int(dateStart1.year())!)
                let prods = productions.filter({ (prods) -> Bool in
                    prods.count > 0
                })
                if self.currentTimeScale == .year {
                    if let first = prods.first{
                        if let last = prods.last{
                            self.currentProduction = abs(first.first!.total-last.last!.total)
                        }
                    }
                }
                self.downloadGroup.leave()
            }
        }
        
        if let data = self.cacheManager.production(year: dateStart2){
            self.previousYearlyProduction = Production.generateProductionArrayForYear(productions: data, year: Int(dateStart2.year())!)
            let prods = data.filter({ (prods) -> Bool in
                prods.count > 0
            })
            if self.currentTimeScale == .year {
                if let first = prods.first{
                    if let last = prods.last{
                        self.previousProduction = abs(first.first!.total-last.last!.total)
                    }
                }
            }
        }else{
            self.downloadGroup.enter()
            RequestManager.getProductionForYear(date: dateStart2) { productions in
                self.cacheManager.saveProduction(year: dateStart2, production: productions)
                self.previousYearlyProduction = Production.generateProductionArrayForYear(productions: productions, year: Int(dateStart2.year())!)
                let prods = productions.filter({ (prods) -> Bool in
                    prods.count > 0
                })
                if self.currentTimeScale == .year {
                    if let first = prods.first{
                        if let last = prods.last{
                            self.previousProduction = abs(first.first!.total-last.last!.total)
                        }
                    }
                }
                self.downloadGroup.leave()
            }
        }
        
        if let data = self.cacheManager.weather(year: dateStart1){
            self.yearlyWeather = Weather.generateWeatherArrayForYear(weathers: data, year: Int(dateStart1.year())!)
        }else{
            self.downloadGroup.enter()
            RequestManager.getWeatherForYear(date: dateStart1) { weather in
                self.yearlyWeather = Weather.generateWeatherArrayForYear(weathers: weather, year: Int(dateStart1.year())!)
                self.cacheManager.saveWeather(year: dateStart1, weather: weather)
                self.downloadGroup.leave()
            }
        }
        
        if let data = self.cacheManager.weather(year: dateStart2){
            self.previousYearlyWeather = Weather.generateWeatherArrayForYear(weathers: data, year: Int(dateStart2.year())!)
        }else{
            self.downloadGroup.enter()
            RequestManager.getWeatherForYear(date: dateStart2) { weather in
                self.previousYearlyWeather = Weather.generateWeatherArrayForYear(weathers: weather, year: Int(dateStart2.year())!)
                self.cacheManager.saveWeather(year: dateStart2, weather: weather)
                self.downloadGroup.leave()
            }
        }
        self.downloadGroup.leave()
    }
    
}
