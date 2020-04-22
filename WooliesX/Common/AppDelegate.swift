//
//  AppDelegate.swift
//  WooliesX
//
//  Created by Jay Salvador on 22/4/20.
//  Copyright © 2020 Jay Salvador. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var isMockData: Bool = false
    
    var window: UIWindow?
    
    class var shared: AppDelegate? {
        
        return UIApplication.shared.delegate as? AppDelegate
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let arguments = CommandLine.arguments
        
        if arguments.contains("-rootMock") {
            
            self.isMockData = true
        }
        
        self.window = UIWindow(frame: UIScreen.main.bounds)

        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        let initialViewController = storyboard.instantiateViewController(withIdentifier: "NavigationViewController")

        self.window?.rootViewController = initialViewController
        
        self.window?.makeKeyAndVisible()
        
        return true
    }

}
