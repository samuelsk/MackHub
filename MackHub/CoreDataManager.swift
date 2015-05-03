//
//  CoreDataManager.swift
//  MackHub
//
//  Created by Samuel Shin Kim on 02/05/15.
//  Copyright (c) 2015 Rafael Fernandes de Oliveira Carvalho. All rights reserved.
//

import CoreData
import UIKit

class CoreDataManager {
    
    static let sharedInstance = CoreDataManager();
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate;
        return appDelegate.managedObjectContext!
        }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate;
        return appDelegate.persistentStoreCoordinator!
        }()
    
    lazy var applicationDocumentsDirectory: NSURL = {
        var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate;
        return appDelegate.applicationDocumentsDirectory;
        }()
    
    func resetCoreData() {
        managedObjectContext.reset();
        let storeURL = applicationDocumentsDirectory.URLByAppendingPathComponent("MackHub.sqlite");
        let fileManager = NSFileManager.defaultManager();
        
        fileManager.removeItemAtURL(storeURL, error: nil);
        
        var error: NSError?
        for store in persistentStoreCoordinator.persistentStores {
            if (!persistentStoreCoordinator.removePersistentStore(store as! NSPersistentStore, error: &error)) {
                println("Error while removing persistent store: \(error), \(error!.userInfo)");
            }
        }
        
        persistentStoreCoordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: nil, error: &error) == nil
    }
    
}