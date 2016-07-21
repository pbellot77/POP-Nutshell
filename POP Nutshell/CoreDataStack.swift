//
//  CoreDataStack.swift
//  POP Nutshell
//
//  Created by Patrick Bellot on 6/14/16, written using Apple Documentation https://developer.apple.com/library/prerelease/content/documentation/Cocoa/Conceptual/CoreData/InitializingtheCoreDataStack.html#//apple_ref/doc/uid/TP40001075-CH4-SW1 and collaborated with Andy Bargh https://www.andybargh.com
//  Copyright © 2016 Bell OS, LLC. All rights reserved.
//

import CoreData
import Foundation

class CoreDataStack: NSObject {
    
    // MARK: Properties
    
    // Set the name of the managed object model.
    let modelName = "VideoModel"
    
    // Lazily load the URL of the apps documents directory. 
    // This is where we're going to store the sqlite database.
    private lazy var applicationDocumentsDirectory: NSURL = {
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        
        return urls[urls.count-1]
    }()
    
    // Load the managed object model from the documents directory.
    private lazy var managedObjectModel: NSManagedObjectModel = {
       let modelURL = NSBundle.mainBundle().URLForResource(self.modelName, withExtension: "momd")!
        
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    // Create the persistent store coordinator using the managed object model and 
    // back it with an SQLite database.
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
       let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent(self.modelName)
        
        do {
            let options = [NSMigratePersistentStoresAutomaticallyOption: true]
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType,
                                                      configuration: nil,
                                                                URL: url,
                                                            options: options)
        } catch let error as NSError {
            print("Error adding persistent store: \(error.localizedDescription)")
            abort()
        }
        
        return coordinator
    }()
    
    // Create an NSManagedObjectContext for main queue.
    lazy var managedObjectContext: NSManagedObjectContext = {
       var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        
        managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        
        return managedObjectContext
    }()
    
    // MARK: Methods
    
    // Convenience method to save the context and handle any errors.
    func saveContext(){
        if managedObjectContext.hasChanges {
            do{
                try managedObjectContext.save()
            } catch let error as NSError {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    override init() {
        super.init()
        NSNotificationCenter.defaultCenter().addObserver(
            self, selector: #selector(mergeChanges(from:)),
                                    name: NSManagedObjectContextObjectsDidChangeNotification,
                                  object: nil)
    }
    
    @objc func mergeChanges(from notification: NSNotification) {
        // NSManagedObjectContext's merge routine ignores updated objects which
        // aren't currently faulted in. To force it to notify interested clients
        // that such objects have been refreshed (i.e NSFetchResultsController)
        // we need to force them to be faulted in ahead of the merge.
        // see: http://www.mikeabdullah.net/merging-saved-changes-betwe.html
        
        print("Merging NSManagedObjectContext changes")
        
        if let updated = notification.userInfo?[NSUpdatedObjectsKey] as? [NSManagedObject] {
            for object in updated {
                // The objects can't be a fault. -existingObjectWithID:error is
                // a nice easy way to achive this in one move.
                do {
                    let _ = try self.managedObjectContext.existingObjectWithID(object.objectID)
                } catch let error as NSError {
                    print("Error merging contexts: \(error) \(error.localizedDescription)")
                }
            }
        }
        
        self.managedObjectContext.mergeChangesFromContextDidSaveNotification(notification)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
}// End of Class