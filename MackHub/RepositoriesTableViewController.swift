//
//  RepositoriesTableViewController.swift
//  MackHub
//
//  Created by Rafael Fernandes de Oliveira Carvalho on 4/27/15.
//  Copyright (c) 2015 Rafael Fernandes de Oliveira Carvalho. All rights reserved.
//

import Foundation
import UIKit

class RepositoriesTableViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    let nKey = "repository"
    let pKey = "Pull"
    let nCenter = NSNotificationCenter.defaultCenter()
    
    lazy var repos: Array<Repository> = {
        return RepositoryManager.sharedInstance.fetchRepositories();
    }()
    
    var selectedCell = -1
    var blackView = UIView()
    
    @IBOutlet weak var tableRepos: UITableView!
    
    var ghManager = GitHubManager.sharedInstance;
    
    //MARK: - Interface
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (repos.isEmpty) {
            ghManager.loadRepos()
            repos = RepositoryManager.sharedInstance.fetchRepositories();
        }
        
        nCenter.addObserver(self, selector: "sendRepo:", name: pKey, object: nil)
    }
    
    //MARK: SearchBar
    
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        
        blackView = UIView(frame: CGRect(x: 0, y: tableRepos.frame.origin.y, width: 2048, height: self.view.frame.size.height))
        blackView.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
        blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "dismissSearchBarFromTouch:"))
        self.view.addSubview(blackView)
        
        return true
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        repos = RepositoryManager.sharedInstance.fetchRepositories();
        searchRepos(searchText);
        tableRepos.reloadData();
    }
    
    func dismissSearchBarFromTouch(tapGesture: UIGestureRecognizer) {
        blackView.removeFromSuperview()
        repositorySearchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        blackView.removeFromSuperview()
        repositorySearchBar.resignFirstResponder()
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        if (searchBar.text.isEmpty) {
            repos = RepositoryManager.sharedInstance.fetchRepositories();
            tableRepos.reloadData();
        }
    }
    
    @IBAction func refreshRepos(sender: AnyObject) {
        CoreDataManager.sharedInstance.resetCoreData();
        ghManager.loadRepos()
        repos = RepositoryManager.sharedInstance.fetchRepositories();
        self.tableRepos.reloadData()
    }
    
    @IBOutlet weak var repositorySearchBar: UISearchBar! {
        didSet {
            repositorySearchBar.delegate = self
            repositorySearchBar.keyboardAppearance = UIKeyboardAppearance.Dark;
        }
    }
    
    func sendRepo(notif: NSNotification){
        nCenter.postNotificationName(nKey, object: nil, userInfo: ["repo":repos[selectedCell]])
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
        cell.updatedAt.text = "Last update: \(ghManager.dateToString(repo.updatedAt))";
        cell.language.text = repo.progLanguage;
        
        cell.hideInfo()
        
        return cell
    }
    
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        performSegueWithIdentifier("ShowDetail", sender: indexPath.row)
//    }
    
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        var cell = tableView.cellForRowAtIndexPath(indexPath) as! RepositoriesTableViewCell
        
        var should = false
        if selectedCell == indexPath.row {
            cell.hideInfo()
            selectedCell = -1
        } else {
            if let previous = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: selectedCell, inSection: indexPath.section)) as? RepositoriesTableViewCell {
                previous.hideInfo()
            }
            cell.showInfo()
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
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == selectedCell {
            return 75
        } else {
            return 50
        }
    }
    
    func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        selectedCell = indexPath.row
    }
    
    // MARK: - Navigation

}
