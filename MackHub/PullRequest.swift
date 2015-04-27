//
//  PullRequest.swift
//  MackHub
//
//  Created by Samuel Shin Kim on 27/04/15.
//  Copyright (c) 2015 Rafael Fernandes de Oliveira Carvalho. All rights reserved.
//

import Foundation

class PullRequest {
    
    var login: String!
    var info: String!
    var lastUpdate: NSDate!
//    var labels: [String]
    
    init(json: NSDictionary) {
        self.login = json.objectForKey("login") as! String;
        self.info = json.objectForKey("description") as! String;
        self.lastUpdate = json.objectForKey("updated-at") as! NSDate;
    }
    
}