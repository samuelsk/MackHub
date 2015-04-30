//
//  GitHubManager.swift
//  MackHub
//
//  Created by Samuel Shin Kim on 27/04/15.
//  Copyright (c) 2015 Rafael Fernandes de Oliveira Carvalho. All rights reserved.
//

import Foundation

class GitHubManager {
    
    static let sharedInstance = GitHubManager();
    
    private let userDefaults = NSUserDefaults.standardUserDefaults();
    
    var isFirstTime = true;
    
    var login: String! {
        willSet {
            userDefaults.setValue(login, forKey: "login");
            userDefaults.synchronize();
            
            self.login = newValue;
        }
    }
    
    private init() {
        if let login = userDefaults.objectForKey("login") as? String {
            self.login = login;
        }
        if let isFirstTime = userDefaults.objectForKey("isFirstTime") as? Bool {
            self.isFirstTime = isFirstTime;
        }
    }
    
}