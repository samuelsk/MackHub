//
//  RepositoryManager.swift
//  MackHub
//
//  Created by Samuel Shin Kim on 29/04/15.
//  Copyright (c) 2015 Rafael Fernandes de Oliveira Carvalho. All rights reserved.
//

import CoreData
import UIKit

class RepositoryManager {
    
    static let sharedInstance = RepositoryManager();
    static let entityName = "Repository";
    
    lazy var managedContext: NSManagedObjectContext = {
        var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate;
        var context = appDelegate.managedObjectContext;
        return context!;
        }()
    
//    lazy var storeCoordinator: NSPersistentStoreCoordinator = {
//        var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate;
//        var store = appDelegate.persistentStoreCoordinator;
//        return store!;
//        }()
    
    func newRepository() -> Repository {
        return NSEntityDescription.insertNewObjectForEntityForName(RepositoryManager.entityName, inManagedObjectContext: managedContext) as! Repository;
    }
    
    func save() {
        var error: NSError?;
        managedContext.save(&error);
        
        if let e = error {
            println("Error while saving: \(error), \(error!.userInfo)");
        }
    }
    
    func fetchRepositories() -> Array<Repository> {
        let fetchRequest = NSFetchRequest(entityName: RepositoryManager.entityName);
        var error: NSError?
        let fetchedResults = managedContext.executeFetchRequest(fetchRequest, error: &error) as? [NSManagedObject];
        
        if let results = fetchedResults as? [Repository] {
            return results;
        } else {
            println("Error while fetching: \(error), \(error!.userInfo)");
        }
        
        return Array<Repository>();
    }
    
//    func removeRepositories() {
//        managedContext.reset();
//        var error: NSError?
//        for store in storeCoordinator.persistentStores {
//            var didRemove = storeCoordinator.removePersistentStore(store as! NSPersistentStore, error: &error);
//            if (!didRemove) {
//                println("Error while removing persistent store: \(error), \(error!.userInfo)");
//            }
//        }
//    }
    
}