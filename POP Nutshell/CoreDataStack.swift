//
//  CoreDataStack.swift
//  POP Nutshell
//
//  Created by Patrick Bellot on 6/14/16, written using Apple Documentation https://developer.apple.com/library/prerelease/content/documentation/Cocoa/Conceptual/CoreData/InitializingtheCoreDataStack.html#//apple_ref/doc/uid/TP40001075-CH4-SW1.
//  Copyright © 2016 Bell OS, LLC. All rights reserved.
//

import UIKit
import CoreData

class CoreDataStack: NSObject {
    
    var managedObjectContext: NSManagedObjectContext
    override init() {
        
        // This resource is the same name as your xcdatamodeld contained in your project.
        guard let modelURL = NSBundle.mainBundle().URLForResource("Video", withExtension:"momd") else {
            fatalError("Error loading model from bundle")
        }
        
        // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
        guard let mom = NSManagedObjectModel(contentsOfURL: modelURL) else {
            fatalError("Error initializing mom from: \(modelURL)")
        }
        
        let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)
        managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = psc
       
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
                
                let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
                let docURL = urls[urls.endIndex-1]
                /* The directory the application uses to store the Core Data store file.
                 This code uses a file named "DataModel.sqlite" in the application's documents directory.
                 */
                
                let storeURL = docURL.URLByAppendingPathComponent("Video.sqlite")
                do {
                    try psc.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: nil)
                } catch {
                    fatalError("Error migrating store: \(error)")
            }
        }
    }
    
    func saveContext() {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch let error as NSError {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}// End of Class