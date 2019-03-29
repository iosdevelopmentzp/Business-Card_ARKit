//
//  AppDelegate.swift
//  Bussines Card
//
//  Created by Imac on 3/11/19.
//  Copyright © 2019 idev. All rights reserved.
//

import UIKit
import SafariServices
import Pulley

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        loadViewControllers()
        
        return true
    }
    
    fileprivate func loadViewControllers () {
        let cardScanstoryboard = UIStoryboard.init(name: String(describing: CardScanViewController.self), bundle: nil)
        guard let arKitVC = cardScanstoryboard.instantiateInitialViewController() else {
            fatalError("Error init \(String(describing: CardScanViewController.self))")
        }
        
    
        let safariVC = SafariViewController()
        
        
        let pulleyViewController = MainPulleyViewController.init(contentViewController: arKitVC, drawerViewController: safariVC )
        
//        safariVC.delegate =  pulleyViewController
        
        pulleyViewController.setDrawerPosition(position: .closed, animated: false)
        pulleyViewController.animationDelay = 0.1
        pulleyViewController.animationDuration = 0.5
        pulleyViewController.drawerTopInset = UIScreen.main.bounds.height * 0.1
        
        self.window?.rootViewController = pulleyViewController
        self.window?.makeKeyAndVisible()
    }

   
}

