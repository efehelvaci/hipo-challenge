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
    
    var flicks              = [Flick]() { didSet { tableView.reloadData() } }
    var page                = 0
    var currentlyPaginating = false
    var currentlySearching : String?

    override func viewDidLoad() {
        super.viewDidLoad()

        FTIndicator.showProgressWithmessage("Loading")
        getFlicks(text: currentlySearching)
        
        navigationController?.hidesBarsOnSwipe = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // What's a flick? whatever
    func getFlicks(text: String?) {
        page = page + 1
        print("Getting page : \(page)")
        
        NetworkManager.sharedInstance.retrieveFlicks(text: text, page: page) { (flicks) in
            self.flicks.append(contentsOf: flicks)
            self.currentlyPaginating = false
            FTIndicator.dismissProgress()
        }
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
