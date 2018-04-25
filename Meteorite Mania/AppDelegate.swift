//
//  AppDelegate.swift
//  Meteorite Mania
//
//  Created by Jonathan Wiley on 4/18/18.
//  Copyright © 2018 LunarLincoln. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        setupAppearance()
        
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        MeteoritesCoreDataStore.saveContext()
    }
    
    func setupAppearance() {
        
        UITabBarItem.appearance().setTitleTextAttributes([.foregroundColor: UIColor(red: 81/255, green: 113/255, blue: 144/255, alpha: 1)], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([.foregroundColor: UIColor(red: 233/255, green: 79/255, blue: 53/255, alpha: 1)], for: .selected)
    }
}
