//
//  RepositoriesTableViewController.swift
//  MackHub
//
//  Created by Rafael Fernandes de Oliveira Carvalho on 4/27/15.
//  Copyright (c) 2015 Rafael Fernandes de Oliveira Carvalho. All rights reserved.
//

import UIKit

class RepositoriesTableViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var repos: NSArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.repos = loadRepos()
    }

    @IBOutlet weak var repositorySearchBar: UISearchBar! {
        didSet {
            repositorySearchBar.delegate = self
        }
    }
    
    func loadRepos() -> NSArray{
        //  Repositorios do usuário
        var url = NSURL(string: "https://api.github.com/users/mackmobile/repos")
        var jsonData = NSData(contentsOfURL: url!)
        
        var error: NSError? = NSError()
        
        var results: NSArray = NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions.MutableContainers, error: &error) as! NSArray
        
        return results
        
        //        // Repositorio selecionado
        //        var url = NSURL(string: "https://api.github.com/repos/mackmobile/Contador")
        //        var jsonData = NSData(contentsOfURL: url!)
        //
        //        var error: NSError? = NSError()
        //
        //        var results: NSDictionary = NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions.MutableContainers, error: &error) as! NSDictionary
        //        // Pull Requests
        //        var url = NSURL(string: "https://api.github.com/repos/mackmobile/iDicionario/pulls?per_page=100")
        //        var jsonData = NSData(contentsOfURL: url!)
        //
        //        var error: NSError? = NSError()
        //
        //        var results: NSArray = NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions.MutableContainers, error: &error) as! NSArray
        //        for result in results{
        //            var user = result["user"] as! NSDictionary
        //            if ((user["login"] as! String) == login.text){
        //                println("ETA CARAIO")
        //            }
        //        }
    }
    
    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.repos.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:RepositoriesTableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! RepositoriesTableViewCell
        
        cell.repositoryName.text = self.repos[indexPath.row]["name"] as? String
        
        return cell
    }
    
    // MARK: SearchBar delegate
    
//    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
//        let cancelButton = UIBarButtonItem(title: "Cancelar", style: UI, target: self, action: "searchBarDidCancel")
//    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
