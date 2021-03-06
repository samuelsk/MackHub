//
//  PullRequestManager.swift
//  MackHub
//
//  Created by Samuel Shin Kim on 27/04/15.
//  Copyright (c) 2015 Rafael Fernandes de Oliveira Carvalho. All rights reserved.
//

import CoreData
import UIKit

class PullRequestManager {
    
    static let sharedInstance = PullRequestManager();
    static let entityName = "PullRequest";
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate;
        return appDelegate.managedObjectContext!
    }()
    
    func newPullRequest() -> PullRequest {
        return NSEntityDescription.insertNewObjectForEntityForName(PullRequestManager.entityName, inManagedObjectContext: managedObjectContext) as! PullRequest;
    }
    
    func save() {
        var error: NSError?;
        managedObjectContext.save(&error);
        
        if let e = error {
            println("Error while saving: \(error), \(error!.userInfo)");
        }
    }
    
    func fetchPullRequests() -> Array<PullRequest> {
        let fetchRequest = NSFetchRequest(entityName: PullRequestManager.entityName);
        var error: NSError?
        let fetchedResults = managedObjectContext.executeFetchRequest(fetchRequest, error: &error) as? [NSManagedObject];
        
        if let results = fetchedResults as? [PullRequest] {
            return results;
        } else {
            println("Error while fetching: \(error), \(error!.userInfo)");
        }
        
        return Array<PullRequest>();
    }
    
    func fetchPullRequest(repo: Repository?) -> PullRequest? {
        let fetchRequest = NSFetchRequest(entityName: PullRequestManager.entityName);
        if repo != nil{
            fetchRequest.predicate = NSPredicate(format: "repoName == %@", repo!.name);
        }
        var error: NSError?
        let fetchedResults = managedObjectContext.executeFetchRequest(fetchRequest, error: &error) as? [NSManagedObject];

        if let results = fetchedResults as? [PullRequest] {
            if results != []{
                return results.last! as PullRequest;
            }
        } else {
            println("Error while fetching: \(error), \(error?.userInfo)");
        }
        
        return nil;
    }
    
}