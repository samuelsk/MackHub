//
//  LabelsViewController.swift
//  MackHub
//
//  Created by Rubens Gondek on 4/30/15.
//  Copyright (c) 2015 Rafael Fernandes de Oliveira Carvalho. All rights reserved.
//

import UIKit

class LabelsViewController: UIViewController {

    var selectedRepo: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadLabels(repo: String){
//     Pull Requests
        var url = NSURL(string: "https://api.github.com/repos/mackmobile/\(repo)/pulls?per_page=100")
        var jsonData = NSData(contentsOfURL: url!)

        var error: NSError? = NSError()

        var results: NSArray = NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions.MutableContainers, error: &error) as! NSArray
        
        var labels: [String]
        for result in results{
            var user = result["user"] as! NSDictionary
            if ((user["login"] as! String) == "rgondek"){
                var label: AnyObject? = user["labels"]
                println("ETA CARAIO, \(label)")
            }
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
