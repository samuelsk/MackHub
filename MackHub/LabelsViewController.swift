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
    var labels: NSArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.labels = loadLabels(selectedRepo)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadLabels(repo: String) -> NSArray{
//     Pull Requests
        var url = NSURL(string: "https://api.github.com/repos/mackmobile/\(repo)/issues?per_page=100")
        var jsonData = NSData(contentsOfURL: url!)

        var error: NSError? = NSError()

        var results: NSArray = NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions.MutableContainers, error: &error) as! NSArray
        
        for result in results{
            var user = result["user"] as! NSDictionary
            if ((user["login"] as! String) == "RGondek"){
                var label: NSArray = result["labels"] as! NSArray
                println("ETA CARAIO, \(label)")
                return label
            }
        }
        return NSArray()
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
