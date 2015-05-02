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
    var ghManager = GitHubManager.sharedInstance;
    
    lazy var pullReq = {
        return PullRequestManager.sharedInstance.fetchPullRequest().first;
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (pullReq == nil) {
            ghManager.loadLabels(selectedRepo)
        }
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
