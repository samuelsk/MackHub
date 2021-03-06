//
//  Repository.swift
//  MackHub
//
//  Created by Samuel Shin Kim on 29/04/15.
//  Copyright (c) 2015 Rafael Fernandes de Oliveira Carvalho. All rights reserved.
//

import CoreData

class Repository: NSManagedObject {
    
    @NSManaged var name: String;
    @NSManaged var info: String;
    @NSManaged var updatedAt: NSDate;
    @NSManaged var progLanguage: String;
    
}