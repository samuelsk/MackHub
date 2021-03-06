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
    private var timer: NSTimer?;
    
    //Whenever a new login will be set, it'll be saved in NSUserDefaults so the user won't need to insert his login again next time he starts the app.
    var login: String! {
        willSet {
            let userDefaults = NSUserDefaults.standardUserDefaults()
            userDefaults.setValue(newValue, forKey: "login");
            userDefaults.synchronize();
        }
    }
    
    //MARK: - Interface
    
    private init() {
        //If a login was set before in NSUserDefaults, it'll be retrieved when GitHubManager is called the first time.
        let userDefaults = NSUserDefaults.standardUserDefaults()
        login = userDefaults.valueForKey("login") as? String;
    }
    
    //MARK: - GitHub API
    
    ///MARK: Data retrieval
    func loadRepos() {
        if Reachability.isConnectedToNetwork() {
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
    }
    
    func loadLabels(repo: Repository){
        if Reachability.isConnectedToNetwork(){
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
                    
                    for lbl in result["labels"] as! NSArray{
                        var l = LabelManager.sharedInstance.newLabel()
                        l.color = lbl["color"] as! String
                        l.name = lbl["name"] as! String
                        pullReq.addLabel(l);
                    }
                    PullRequestManager.sharedInstance.save()
                    break;
                }
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
        
        if Reachability.isConnectedToNetwork(){
            var pullRequests = PullRequestManager.sharedInstance.fetchPullRequests();
            
            for pullReq in pullRequests {
                var url = NSURL(string: "https://api.github.com/repos/mackmobile/\(pullReq.repoName)/issues?per_page=100&client_id=9e6db8dfc8a1aef27931&client_secret=a39f6583d22d099a4cbc762ee5afc863e111f215")
                var jsonData = NSData(contentsOfURL: url!)
                var error: NSError?
                var results: NSArray = NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions.MutableContainers, error: &error) as! NSArray
                
                for result in results{
                    var user = result["user"] as! NSDictionary
                    if ((user["login"] as! String) == login){
                        var updatedAt = stringToDate(result["updated_at"] as! String);
                        if (pullReq.updatedAt != updatedAt) {
                            pullReq.updatedAt = updatedAt;
                            
                            var labels: [Label] = [];
                            for lbl in result["labels"] as! NSArray{
                                var l = LabelManager.sharedInstance.newLabel();
                                l.color = lbl["color"] as! String;
                                l.name = lbl["name"] as! String;
                                labels.append(l);
                            }
                            
                            pullReq.labels = NSSet(array: labels);
                            PullRequestManager.sharedInstance.save()
                            
                            var notif = UILocalNotification()
                            notif.fireDate = NSDate(timeIntervalSinceNow: 0)
                            notif.alertBody = "O PullRequest do repositório \(pullReq.repoName) foi atualizado"
                            notif.alertTitle = "PullRequest atualizado"
                            notif.soundName = UILocalNotificationDefaultSoundName
                            notif.timeZone = NSTimeZone.defaultTimeZone()
                            notif.applicationIconBadgeNumber = 1
                            UIApplication.sharedApplication().scheduleLocalNotification(notif)
                        }
                    }
                }
            }
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