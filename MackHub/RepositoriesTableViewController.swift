//
//  RepositoriesTableViewController.swift
//  MackHub
//
//  Created by Rafael Fernandes de Oliveira Carvalho on 4/27/15.
//  Copyright (c) 2015 Rafael Fernandes de Oliveira Carvalho. All rights reserved.
//

import UIKit

class RepositoriesTableViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    let nKey = "repository"
    let nCenter = NSNotificationCenter.defaultCenter()
    
    lazy var repos: Array<Repository> = {
        return RepositoryManager.sharedInstance.fetchRepositories();
    }()
    
    var selectedCell = -1
    
    @IBOutlet weak var tableRepos: UITableView!
    
    var ghManager = GitHubManager.sharedInstance;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadRepos()
        repos = RepositoryManager.sharedInstance.fetchRepositories();
    }

    @IBAction func refreshRepos(sender: AnyObject) {
        loadRepos()
        self.tableRepos.reloadData()
    }
    
    @IBOutlet weak var repositorySearchBar: UISearchBar! {
        didSet {
            repositorySearchBar.delegate = self
            repositorySearchBar.keyboardAppearance = UIKeyboardAppearance.Dark;
        }
    }
    
    func loadRepos() {
        print("HELLO");
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
        
        let repo = self.repos[indexPath.row];
        cell.repositoryName.text = repo.name
        cell.updatedAt.text = "Updated: \(dateToString(repo.lastUpdate))";
        cell.language.text = repo.progLanguage;
        
        cell.updatedAt.hidden = true
        cell.language.hidden = true
        
        return cell
    }
    
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        performSegueWithIdentifier("ShowDetail", sender: indexPath.row)
//    }
    
    func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        nCenter.postNotificationName(nKey, object: repos[indexPath.row])
        
        self.navigationController?.pushViewController(LabelsViewController(), animated: true)
    }
    
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        var should = false
        if selectedCell == indexPath.row {
            selectedCell = -1
        } else {
            should = true
            selectedCell = indexPath.row
        }
        tableView.beginUpdates()
        tableView.endUpdates()
        
        return true
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row != selectedCell {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            var cell = tableView.cellForRowAtIndexPath(indexPath) as! RepositoriesTableViewCell
            cell.updatedAt.hidden = true
            cell.language.hidden = true
        }
        else{
            var cell = tableView.cellForRowAtIndexPath(indexPath) as! RepositoriesTableViewCell
            cell.updatedAt.hidden = false
            cell.language.hidden = false
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == selectedCell {
            return 100
        } else {
            return 50
        }
    }
    
    var blackView = UIView()
    
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        
        blackView = UIView(frame: CGRect(x: 0, y: tableRepos.frame.origin.y, width: 2048, height: self.view.frame.size.height))
        blackView.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
        blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "dismissSearchBarFromTouch:"))
        self.view.addSubview(blackView)
        
        return true
    }
    
    func dismissSearchBarFromTouch(tapGesture: UIGestureRecognizer) {
        blackView.removeFromSuperview()
        repositorySearchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        blackView.removeFromSuperview()
        repositorySearchBar.resignFirstResponder()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    
    


}
