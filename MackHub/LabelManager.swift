//
//  LabelManager.swift
//  MackHub
//
//  Created by Rubens Gondek on 4/30/15.
//  Copyright (c) 2015 Rafael Fernandes de Oliveira Carvalho. All rights reserved.
//

import CoreData
import UIKit

class LabelManager {
    
    static let sharedInstance = LabelManager();
    static let entityName = "Label";
    
    lazy var managedContext: NSManagedObjectContext = {
        var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate;
        var context = appDelegate.managedObjectContext;
        return context!;
        }()
    
    func newLabel() -> Label {
        return NSEntityDescription.insertNewObjectForEntityForName(LabelManager.entityName, inManagedObjectContext: managedContext) as! Label;
    }
    
    func save() {
        var error: NSError?;
        managedContext.save(&error);
        
        if let e = error {
            println("Error while saving: \(error), \(error!.userInfo)");
        }
    }
    
    func fetchLabels() -> Array<Label> {
        let fetchRequest = NSFetchRequest(entityName: LabelManager.entityName);
        var error: NSError?
        let fetchedResults = managedContext.executeFetchRequest(fetchRequest, error: &error) as? [NSManagedObject];
        
        if let results = fetchedResults as? [Label] {
            return results;
        } else {
            println("Error while fetching: \(error), \(error!.userInfo)");
        }
        
        return Array<Label>();
    }
}