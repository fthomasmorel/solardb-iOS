//
//  RequestManager.swift
//  SolarDB
//
//  Created by Florent THOMAS-MOREL on 11/23/16.
//  Copyright © 2016 Florent THOMAS-MOREL. All rights reserved.
//

import Foundation
import Alamofire

//let kAPIHost = "http://localhost"
//let kAPIHost = "http://192.168.1.70"
//let kAPIHost = "http://10.132.8.136"
let kAPIHost = "https://solardb.thomasmorel.io"

class RequestManager: AnyObject {
    
    static func record(production: Production){
        let params: [String: AnyObject] = [
            "date": production.date.toString() as AnyObject,
            "production": production.production as AnyObject,
            "total": production.total as AnyObject
        ]
        print(params)
        let _ = Alamofire.request(kAPIHost + "/production", method: .post, parameters: params, encoding: JSONEncoding.default)
        //let _ = Alamofire.request(.post, url, parameters: params, encoding: .json)
    }
    
    static func getProductionForDay(date: Date, completion: @escaping (Production?) -> ()){
        Alamofire.request(kAPIHost + "/production/day?date=\(date.toString())").responseJSON { response in
            if let json = response.result.value as? [String : AnyObject] {
                completion(Production.parse(json: json))
            }else{
                completion(.none)
            }
        }
    }
    
    static func getProductionForMonth(date: Date, completion: @escaping ([Production]) -> ()){
        Alamofire.request(kAPIHost + "/production/month/detail?date=\(date.toString())").responseJSON { response in
            if let json = response.result.value {
                let productions = Production.parse(array: json as! [[String: AnyObject]])
                completion(productions)
            }else{
                completion([])
            }
        }
    }
    
    static func getProductionForYear(date: Date, completion: @escaping ([[Production]]) -> ()){
        Alamofire.request(kAPIHost + "/production/year/detail?date=\(date.toString())").responseJSON { response in
            if let json = response.result.value as? [[[String: AnyObject]]] {
                let productions = json.map({ (array) -> [Production] in
                    Production.parse(array: array )
                })
                completion(productions)
            }else{
                completion([])
            }
        }
    }
    
    static func getWeatherForDay(date: Date, completion: @escaping ([String: AnyObject]) -> ()){
        Alamofire.request(kAPIHost + "/weather/day?date=\(date.toString())").responseJSON { response in
            if let json = response.result.value {
                completion(json as! [String : AnyObject])
            }else{
                completion([:])
            }
        }
    }
    
    static func getWeatherForMonth(date: Date, completion: @escaping ([Weather]) -> ()){
        Alamofire.request(kAPIHost + "/weather/month?date=\(date.toString())").responseJSON { response in
            if let json = response.result.value {
                let weathers = Weather.parse(array: json as! [[String: AnyObject]])
                completion(weathers)
            }else{
                completion([])
            }
        }
    }
    
    static func getWeatherForYear(date: Date, completion: @escaping ([[Weather]]) -> ()){
        Alamofire.request(kAPIHost + "/weather/year?date=\(date.toString())").responseJSON { response in
            if let json = response.result.value as? [[[String: AnyObject]]] {
                let weathers = json.map({ (array) -> [Weather] in
                    Weather.parse(array: array )
                })
                completion(weathers)
            }else{
                completion([])
            }
        }
    }
    
}
