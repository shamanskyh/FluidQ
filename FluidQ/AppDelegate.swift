//
//  AppDelegate.swift
//  FluidQ
//
//  Created by Harry Shamansky on 9/29/15.
//  Copyright © 2015 Harry Shamansky. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    /// the shared multipeer manager for the app
    let multipeerManager = MultipeerManager()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        multipeerManager.clientDelegate = self
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

extension AppDelegate: MultipeerManagerClientDelegate {
    func instrumentsDidSend(manager: MultipeerManager, instruments: [Instrument]) {
        let magicSheetViewController = UIViewController()
        magicSheetViewController.view.backgroundColor = UIColor.blackColor()
        magicSheetViewController.title = "Magic Sheet"
        magicSheetViewController.tabBarItem = UITabBarItem(title: "Magic Sheet", image: UIImage(named: "MagicSheet"), tag: 0)
        
        if let currentControllers = (self.window?.rootViewController as? UITabBarController)!.viewControllers {
            dispatch_async(dispatch_get_main_queue()) {
                let tabBarControllers = currentControllers + [magicSheetViewController]
                (self.window?.rootViewController as? TabBarController)?.setViewControllers(tabBarControllers, animated: true)
                (self.window?.rootViewController as? TabBarController)?.selectedViewController = magicSheetViewController
                
                // TODO: Init a new view controller class with the instruments. Group instruments by purpose and display magic sheet.
            }
        }
    }
}

