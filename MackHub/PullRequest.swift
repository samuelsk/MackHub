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
    @NSManaged var labels: NSSet
    @NSManaged var repository: Repository
    
}