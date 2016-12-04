//
//  AppDelegate.swift
//  SolarDB
//
//  Created by Florent THOMAS-MOREL on 11/18/16.
//  Copyright © 2016 Florent THOMAS-MOREL. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    let kSolarDBNotificationUUID = "kSolarDBNotificationUUID"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        let calendar: Calendar = Calendar.current
        var dateFire = Date()
        
        var fireComponents = calendar.dateComponents([.day, .month, .year, .hour, .minute], from: dateFire)
        
        if (fireComponents.hour! >= 7) {
            dateFire = dateFire.addingTimeInterval(86400)
            fireComponents = calendar.dateComponents([.day, .month, .year, .hour, .minute], from: dateFire)
        }
        
        fireComponents.hour = 7
        fireComponents.minute = 0
        
        dateFire = calendar.date(from: fireComponents)!
        
        let localNotification = UILocalNotification()
        localNotification.fireDate = dateFire
        localNotification.alertBody = "Penses à saisir le relevé des panneaux solaires ☀️😎📈"
        localNotification.repeatInterval = .day
        
        UIApplication.shared.scheduleLocalNotification(localNotification)
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

