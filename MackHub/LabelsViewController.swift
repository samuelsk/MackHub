//
//  LabelsViewController.swift
//  MackHub
//
//  Created by Rubens Gondek on 4/30/15.
//  Copyright (c) 2015 Rafael Fernandes de Oliveira Carvalho. All rights reserved.
//

import UIKit

class LabelsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let nKey = "repository"
    let pKey = "Pull"
    let nCenter = NSNotificationCenter.defaultCenter()
    
    var selectedRepo: Repository!
    var ghManager = GitHubManager.sharedInstance;
    
    var labels: NSArray = []
    
    var pullReq: PullRequest?
    
    @IBOutlet weak var repoInfo: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nCenter.addObserver(self, selector: "load:", name: nKey, object: nil)
    
        nCenter.postNotificationName(pKey, object: nil)

        self.navigationItem.title = selectedRepo.name

        pullReq = PullRequestManager.sharedInstance.fetchPullRequest(selectedRepo);
        
        // Do any additional setup after loading the view.
    }
    
    func load(notif: NSNotification){
        let uInfo = notif.userInfo as! [String:Repository]
        selectedRepo = uInfo["repo"]
        
        if pullReq == nil {
            ghManager.loadLabels(selectedRepo)
            pullReq = PullRequestManager.sharedInstance.fetchPullRequest(selectedRepo);
            labels = NSArray(objects: pullReq!.labels.allObjects)
            if labels.count != 0{
                labels = labels[0] as! NSArray
                let sd = NSSortDescriptor(key: "name", ascending: true)
                labels = labels.sortedArrayUsingDescriptors([sd])
            }
        }
        else{
            labels = NSArray()
        }
        
        self.navigationItem.title = selectedRepo.name
        if selectedRepo.info != ""{
            repoInfo.text = selectedRepo.info
        }
        else{
            repoInfo.text = "Nenhuma descrição disponível"
        }
    }
    
    // MARK - Table View
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return labels.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: LabelsCell = tableView.dequeueReusableCellWithIdentifier("Label", forIndexPath: indexPath) as! LabelsCell
        
        let l = labels[indexPath.row] as! Label
        
        cell.backgroundColor = UIColor(hexa: l.color)
        cell.lblName.text = l.name
        
        return cell
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

extension UIColor{
    convenience init(var hexa: String){
        var rgb: UInt32 = 0
        var s: NSScanner = NSScanner(string: hexa)
        
        s.scanLocation = 0
        s.scanHexInt(&rgb)
        
        self.init(red: CGFloat((rgb & 0xFF0000) >> 16)/255, green: CGFloat((rgb & 0x00FF00) >> 8)/255, blue: CGFloat((rgb & 0x0000FF) >> 0)/255, alpha: 1)
    }
}
