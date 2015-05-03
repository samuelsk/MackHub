//
//  GitHubManager.swift
//  MackHub
//
//  Created by Samuel Shin Kim on 27/04/15.
//  Copyright (c) 2015 Rafael Fernandes de Oliveira Carvalho. All rights reserved.
//

import UIKit

class GitHubManager {
    
    //MARK: - Variable declaration
    
    //Singleton
    static let sharedInstance = GitHubManager();
    
    //Auxiliary variables
    private let userDefaults = NSUserDefaults.standardUserDefaults();
    private var timer: NSTimer?;
    
    var counter = 1;
    
    //Whenever a new login will be set, it'll be saved in NSUserDefaults so the user won't need to insert his login again next time he starts the app.
    var login: String! {
        willSet {
            userDefaults.setValue(login, forKey: "login");
            userDefaults.synchronize();
            
            self.login = newValue;
        }
    }
    
    //MARK: - Interface
    
    private init() {
        //If a login was set before in NSUserDefaults, it'll be retrieved when GitHubManager is called the first time.
        if let login = userDefaults.objectForKey("login") as? String {
            self.login = login;
        }
    }
    
    //MARK: - GitHub API
    
    ///MARK: Data retrieval
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
            var arg: AnyObject? = result["description"];
            if arg!.isEqual(NSNull()) {
                repo.info = "";
            } else {
                repo.info = result["description"] as! String;
            }
            repo.updatedAt = stringToDate(result["updated_at"] as! String);
            arg = result["language"];
            if arg!.isEqual(NSNull()) {
                repo.progLanguage = "Language unknown";
            } else {
                repo.progLanguage = result["language"] as! String;
            }
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
            if ((user["login"] as! String) == login){
                // Salvar pull request
                var pullReq = PullRequestManager.sharedInstance.newPullRequest()
                pullReq.repoName = repo.name
                pullReq.updatedAt = stringToDate(result["updated_at"] as! String);
//                pullReq.repository = repo
                for lbl in result["labels"] as! NSArray{
                    var l = LabelManager.sharedInstance.newLabel()
                    l.color = lbl["color"] as! String
                    l.name = lbl["name"] as! String
//                    l.pullRequest = pullReq
                    pullReq.addLabel(l);
                }
//                PullRequestManager.sharedInstance.save()
                break;
            }
        }
    }
    
    //MARK: Data updates verification
    
    func checkForUpdatesWithInterval(interval: Double) {
        let task = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler({ () -> Void in
            self.timer?.invalidate();
        });
        timer?.invalidate();
        timer = NSTimer.scheduledTimerWithTimeInterval(interval, target: self, selector: "checkUpdates", userInfo: nil, repeats: true);
    }
    
    @objc func checkUpdates() {
        
        println("\(counter) Checking updates...");
        counter++;
        
        var pullRequests = PullRequestManager.sharedInstance.fetchPullRequests();
        
        for pullReq in pullRequests {
            var url = NSURL(string: "https://api.github.com/repos/mackmobile/\(pullReq.repoName)/issues?per_page=100&client_id=9e6db8dfc8a1aef27931&client_secret=a39f6583d22d099a4cbc762ee5afc863e111f215")
            var jsonData = NSData(contentsOfURL: url!)
            var error: NSError?
            var results: NSArray = NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions.MutableContainers, error: &error) as! NSArray
            
//            for result in results{
//                var user = result["user"] as! NSDictionary
//                if ((user["login"] as! String) == login){
//                    
//                    if (pullReq.updatedAt != stringToDate(result["updated_at"] as! String)) {
//                        
//                        println("\(counter) Update found in \(pullReq.repoName)!");
//                        
////                        for lbl in result["labels"] as! NSArray{
////                            var l = LabelManager.sharedInstance.newLabel()
////                            l.color = lbl["color"] as! String
////                            l.name = lbl["name"] as! String
////                            l.pullRequest = pullReq
////                            LabelManager.sharedInstance.save()
////                        }
//                        
//                        var labels: Array<Label>!
//                        for lbl in result["labels"] as! NSArray{
//                            var l = LabelManager.sharedInstance.newLabel();
//                            l.color = lbl["color"] as! String;
//                            l.name = lbl["name"] as! String;
//                            l.pullRequest = pullReq;
//                            labels.append(l);
//                        }
//                        pullReq.labels = NSSet(array: labels);
//                        PullRequestManager.sharedInstance.save()
//                    }
//                }
//            }
        }
        
        
    }
    
    //MARK: - Auxiliary functions
    
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