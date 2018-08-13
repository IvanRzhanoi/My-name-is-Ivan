//
//  SearchTableViewController.swift
//  My name is Ivan
//
//  Created by Ivan Rzhanoi on 14/08/2018.
//  Copyright © 2018 Ivan Rzhanoi. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class SearchTableViewController: UITableViewController, UISearchBarDelegate {
    
//    @IBOutlet weak var searchBar: UISearchBar!
    
    var searchDetail = [Search]()
    var filteredData = [Search]()
    var isSearching = false
    var detail: Search!
    var recipient: String!
    var messageID: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let searchController = UISearchController(searchResultsController: nil)
        
//        navigationItem.hidesSearchBarWhenScrolling = false
//        searchController.searchBar.placeholder = "Search"
//        searchController.searchBar.tintColor = .white
        
        
       
        //Setup Search Controller
//        self.searchController.obscuresBackgroundDuringPresentation = false
//        self.searchController.searchBar.placeholder = "Search".localized()
//        self.searchController.searchBar.barStyle = .black
//        self.searchController.searchBar.delegate = self
//        self.definesPresentationContext = true
//        self.navigationItem.searchController = searchController
//
        
        
        navigationItem.searchController = searchController
        
        tableView.delegate = self
        tableView.dataSource = self
        searchController.searchBar.delegate = self
        searchController.searchBar.returnKeyType = UIReturnKeyType.done

        
        Database.database().reference().child("users").observe(.value, with: { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                self.searchDetail.removeAll()
                
                // Checking the user detail
                print(snapshot)
                
                for data in snapshot {
                    if let postDictionary = data.value as? Dictionary<String, AnyObject> {
                        let key = data.key
                        let post = Search(userKey: key, postData: postDictionary)
                        print(key)
                        if key == KeychainWrapper.standard.string(forKey: "uid") {
                            continue
                        }
                        self.searchDetail.append(post)
                    }
                }
            }
            
            self.tableView.reloadData()
        })
    }


    
    //MARK: SEARCH BAR DELEGATE
//    extension ViewController: UISearchBarDelegate
//    {
//        func searchBarTextDidBeginEditing(_ searchBar: UISearchBar)
//        {
//            //Show Cancel
//            searchBar.setShowsCancelButton(true, animated: true)
//            searchBar.tintColor = .white
//        }
//
//        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
//        {
//            //Filter function
//            self.filterFunction(searchText: searchText)
//        }
//
//        func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
//        {
//            //Hide Cancel
//            searchBar.setShowsCancelButton(false, animated: true)
//            searchBar.resignFirstResponder()
//
//            guard let term = searchBar.text , term.trim().isEmpty == false else {
//
//                //Notification "White spaces are not permitted"
//                return
//            }
//
//            //Filter function
//            self.filterFunction(searchText: term)
//        }
//
//        func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
//        {
//            //Hide Cancel
//            searchBar.setShowsCancelButton(false, animated: true)
//            searchBar.text = String()
//            searchBar.resignFirstResponder()
//
//            //Filter function
//            self.filterFunction(searchText: searchBar.text)
//        }
//    }
    
    
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return filteredData.count
        } else {
            return searchDetail.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchData: Search!
        if isSearching {
            searchData = filteredData[indexPath.row]
        } else {
            searchData = searchDetail[indexPath.row]
        }
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell") as? SearchTableViewCell {
            cell.configureCell(searchDetail: searchData)
            return cell
        } else {
            return SearchTableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isSearching {
            recipient = filteredData[indexPath.row].userKey
        } else {
            recipient = searchDetail[indexPath.row].userKey
        }
        
        performSegue(withIdentifier: "toMessage", sender: nil)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            isSearching = false
            view.endEditing(true)
            tableView.reloadData()
        } else {
            isSearching = true
//            filteredData = searchDetail.filter({ $0.username == searchBar.text!.lowercased() })
            filteredData = searchDetail.filter({ $0.username.contains(searchBar.text!.lowercased()) })
            tableView.reloadData()
        }
    }
}
