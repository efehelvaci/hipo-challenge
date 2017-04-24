//
//  MainPageVC.swift
//  Hipoflickr
//
//  Created by Efe Helvacı on 23.04.2017.
//  Copyright © 2017 Efe Helvacı. All rights reserved.
//

import UIKit
import SwifterSwift
import FTIndicator

class MainPageVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var flicks              = [Flick]() { didSet { tableView.reloadData() } } // When images are updated, update table
    var page                = 0  // Pagination page :D
    var currentlyPaginating = false // To call scroll view delegate method only once at the end of the page
    var currentlySearching  : String? // Search bar text - Set nil if bar is empty, else set searchBar.text
    var refreshControl      : UIRefreshControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Pull to refresh
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshImages), for: .valueChanged)
        tableView.addSubview(refreshControl)

        FTIndicator.showProgressWithmessage("Loading") // Loading indicator
        getFlicks(text: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Flick = image
    // Gets images through NetworkManager
    func getFlicks(text: String?) {
        page = page + 1
        print("Getting page : \(page)")
        
        NetworkManager.sharedInstance.retrieveFlicks(text: text, page: page) { (flicks) in
            self.flicks.append(contentsOf: flicks)
            self.currentlyPaginating = false
            self.refreshControl.endRefreshing()
            FTIndicator.dismissProgress()
            
        }
    }
    
    // Pull to refresh
    func refreshImages() {
        flicks.removeAll()
        page = 0
        currentlyPaginating = false
        
        getFlicks(text: self.currentlySearching)

    }
}

// MARK: - Table view methods

extension MainPageVC : UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flicks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "flickCell", for: indexPath) as? FlickTableViewCell {
            cell.setCell(flick: flicks[indexPath.row])
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "FlickDetailVC") as! FlickDetailVC
        vc.imageURL = flicks[indexPath.row].imageURL
        show(vc, sender: self)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if !currentlyPaginating {
            let offset = (scrollView.contentOffset.y - (scrollView.contentSize.height - scrollView.frame.size.height))
            
            if (offset >= 0 && offset <= 100) {
                currentlyPaginating = true
                getFlicks(text: currentlySearching)
            }
            
        }
    }
}

// MARK: -Search bar methods

extension MainPageVC : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        flicks.removeAll()
        page = 0
        currentlyPaginating = false
        
        if let searchText = searchBar.text {
            if searchText == "" {self.currentlySearching = nil}
            else { self.currentlySearching = searchText }
        } else {
            self.currentlySearching = nil
        }
        
        getFlicks(text: self.currentlySearching)
    }
    
    // If search bar is empty, get latest images
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            searchBar.resignFirstResponder()
            flicks.removeAll()
            page = 0
            currentlyPaginating = false
            self.currentlySearching = nil
            
            getFlicks(text: self.currentlySearching)
        }
    }
}
