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
        
        if (repos.isEmpty) {
            ghManager.loadRepos()
        }
        repos = RepositoryManager.sharedInstance.fetchRepositories();
    }

    @IBAction func refreshRepos(sender: AnyObject) {
        ghManager.loadRepos()
        self.tableRepos.reloadData()
    }
    
    @IBOutlet weak var repositorySearchBar: UISearchBar! {
        didSet {
            repositorySearchBar.delegate = self
            repositorySearchBar.keyboardAppearance = UIKeyboardAppearance.Dark;
        }
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
        cell.updatedAt.text = "Updated: \(ghManager.dateToString(repo.updatedAt))";
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
    
    func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        
        nCenter.postNotificationName(nKey, object: nil, userInfo: ["repo":repos[indexPath.row]])
        
        let vc = LabelsViewController()
        self.navigationController?.pushViewController(vc, animated: true)
//        performSegueWithIdentifier("ShowDetail", sender: nil)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "ShowDetail" {
            let lvc: LabelsViewController = segue.destinationViewController as! LabelsViewController
            lvc.selectedRepo = repos[2]
            segue.perform()
        }
    }
    
    


}
