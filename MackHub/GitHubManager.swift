//
//  GitHubManager.swift
//  MackHub
//
//  Created by Samuel Shin Kim on 27/04/15.
//  Copyright (c) 2015 Rafael Fernandes de Oliveira Carvalho. All rights reserved.
//

import UIKit

class GitHubManager {
    
    static let sharedInstance = GitHubManager();
    
    private let userDefaults = NSUserDefaults.standardUserDefaults();
    
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
    }
    
    func loadRepos() {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        //  Repositorios do usuário
        var url = NSURL(string: "https://api.github.com/users/mackmobile/repos?client_id=9e6db8dfc8a1aef27931&client_secret=a39f6583d22d099a4cbc762ee5afc863e111f215")
        var jsonData = NSData(contentsOfURL: url!)
        
        var error: NSError? = NSError()
        //
        var results: NSArray = NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions.MutableContainers, error: &error) as! NSArray
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        
        for result in results {
            var repo = RepositoryManager.sharedInstance.newRepository();
            repo.name = result["name"] as! String;
            repo.info = result["description"] as! String;
            repo.lastUpdate = stringToDate(result["updated_at"] as! String);
            repo.progLanguage = result["language"] as! String;
            RepositoryManager.sharedInstance.save();
        }
    }
    
    func loadLabels(repo: Repository){
        //     Pull Request
        var url = NSURL(string: "https://api.github.com/repos/mackmobile/\(repo.name)/issues?per_page=100&client_id=9e6db8dfc8a1aef27931&client_secret=a39f6583d22d099a4cbc762ee5afc863e111f215")
        var jsonData = NSData(contentsOfURL: url!)
        
        var error: NSError? = NSError()
        
        var results: NSArray = NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions.MutableContainers, error: &error) as! NSArray
        
        for result in results{
            var user = result["user"] as! NSDictionary
            if ((user["login"] as! String) == "RGondek"){
                // Salvar pull request
                var pullReq = PullRequestManager.sharedInstance.newPullRequest()
                pullReq.repoName = repo.name
                pullReq.repository = repo
                for lbl in result["labels"] as! NSArray{
                    var l = LabelManager.sharedInstance.newLabel()
                    l.color = lbl["color"] as! String
                    l.name = lbl["name"] as! String
                    l.pullRequest = pullReq
                    LabelManager.sharedInstance.save()
                }
                PullRequestManager.sharedInstance.save()
            }
        }
    }
    
    func stringToDate(str: String) -> NSDate {
        let dateFormatter = NSDateFormatter();
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'";
        return dateFormatter.dateFromString(str)!;
    }
    
    func dateToString(date: NSDate) -> String {
        let dateFormatter = NSDateFormatter();
        dateFormatter.dateFormat = "dd/MM";
        return dateFormatter.stringFromDate(date);
    }
    
}