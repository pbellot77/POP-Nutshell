//
//  AppDelegate.swift
//  POP Nutshell
//
//  Created by Patrick Bellot on 4/27/16 and collaberated with Andy Bargh - https://www.andybargh.com.
//  Copyright © 2016 Bell OS, LLC. All rights reserved.
//

import UIKit
import CoreData
import SwiftyJSON

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var coreDataStack: CoreDataStack?
    var apiService: YouTubeService?
    var syncEngine: YouTubeSyncEngine?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        self.coreDataStack = CoreDataStack()
        self.apiService = YouTubeService()
        self.syncEngine = YouTubeSyncEngine(context: self.coreDataStack!.managedObjectContext, service: self.apiService!)
        
        self.syncEngine!.sync()
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        self.coreDataStack?.saveContext()
    }
}