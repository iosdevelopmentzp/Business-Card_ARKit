//
//  AppDelegate.swift
//  Bussines Card
//
//  Created by Imac on 3/11/19.
//  Copyright © 2019 idev. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        let menuStoryboard = UIStoryboard(name: String(describing: MenuViewController.self), bundle: nil)
        
        let menuVC = menuStoryboard.instantiateViewController(withIdentifier: String(describing: MenuViewController.self))

        let navigationController = UINavigationController(rootViewController: menuVC)
        
        self.window?.rootViewController = nil
        self.window?.rootViewController = navigationController
        
        self.window?.makeKeyAndVisible()
        
        return true
    }
}

