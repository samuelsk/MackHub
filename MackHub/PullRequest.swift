//
//  PullRequest.swift
//  MackHub
//
//  Created by Samuel Shin Kim on 27/04/15.
//  Copyright (c) 2015 Rafael Fernandes de Oliveira Carvalho. All rights reserved.
//

import CoreData

class PullRequest: NSManagedObject {
    
    @NSManaged var repoName: String
    @NSManaged var updatedAt: NSDate
    @NSManaged var labels: NSSet
    
    func addLabel(label: Label) {
        var labels = self.mutableSetValueForKey("labels")
        labels.addObject(label)
    }
    
}