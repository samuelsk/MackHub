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
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate;
        return appDelegate.managedObjectContext!
        }()
    
    func newRepository() -> Repository {
        return NSEntityDescription.insertNewObjectForEntityForName(RepositoryManager.entityName, inManagedObjectContext: managedObjectContext) as! Repository;
    }
    
    func save() {
        var error: NSError?;
        managedObjectContext.save(&error);
        
        if let e = error {
            println("Error while saving: \(error), \(error!.userInfo)");
        }
    }
    
    func fetchRepositories() -> Array<Repository> {
        let fetchRequest = NSFetchRequest(entityName: RepositoryManager.entityName);
        var error: NSError?
        let fetchedResults = managedObjectContext.executeFetchRequest(fetchRequest, error: &error) as? [NSManagedObject];
        
        if let results = fetchedResults as? [Repository] {
            return results;
        } else {
            println("Error while fetching: \(error), \(error!.userInfo)");
        }
        
        return Array<Repository>();
    }
        
}