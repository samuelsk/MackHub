//
//  LabelsViewController.swift
//  MackHub
//
//  Created by Rubens Gondek on 4/30/15.
//  Copyright (c) 2015 Rafael Fernandes de Oliveira Carvalho. All rights reserved.
//

import UIKit

class LabelsViewController: UIViewController {

    var selectedRepo: Repository!
    
//    = {
//        return PullRequestManager.sharedInstance.fetchPullRequests();
//        }()
    
    var labels: NSArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadLabels(selectedRepo)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadLabels(repo: Repository){
//        if pullReq.isEqual(nil){
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
                    pullReq.login = user["login"] as! String
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
//        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
