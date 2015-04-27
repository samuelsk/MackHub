//
//  CDPullRequest.swift
//  MackHub
//
//  Created by Samuel Shin Kim on 27/04/15.
//  Copyright (c) 2015 Rafael Fernandes de Oliveira Carvalho. All rights reserved.
//

import Foundation
import CoreData

class CDPullRequest: NSManagedObject {
    
    var login: String!
    var info: String!
    var lastUpdate: NSDate!
    
}