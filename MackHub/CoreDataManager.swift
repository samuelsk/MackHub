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
    
//    func resetApplicationModel() {
//        var error: NSError?
//        managedObjectContext.reset();
//        var storeURL = applicationDocumentsDirectory.URLByAppendingPathComponent("MackHub.sqlite");
//        NSFileManager.defaultManager().removeItemAtURL(storeURL, error: nil);
//        for managedObject in managedObjectContext.registeredObjects {
//            managedObjectContext.deleteObject(managedObject as! NSManagedObject);
//        }
//        
//        persistentStoreCoordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: nil, error: &error);
////            println("Error while adding persistent store: \(error), \(error!.userInfo)");
//    }
//    
//    func removeRepositories() {
//        managedObjectContext.reset();
//        var error: NSError?
//        for store in persistentStoreCoordinator.persistentStores {
//            var didRemove = persistentStoreCoordinator.removePersistentStore(store as! NSPersistentStore, error: &error);
//            if (!didRemove) {
//                println("Error while removing persistent store: \(error), \(error!.userInfo)");
//            }
//        }
//    }
    
}