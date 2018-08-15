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
    
    // View which contains the loading text and the activityIndicator
    let loadingView = UIView()
    
    // Activity Indicator shown during load the TableView
    let activityIndicator = UIActivityIndicatorView()
    
    // Text shown during load the TableView
    let loadingLabel = UILabel()
    
    var searchDetail = [Search]()
    var filteredData = [Search]()
    var isSearching = false
    var detail: Search!
    var recipient: String!
    var messageID: String!
    var recipientName: String!

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
        
        navigationItem.searchController = searchController
        
        tableView.delegate = self
        tableView.dataSource = self
        searchController.searchBar.delegate = self
        searchController.searchBar.returnKeyType = UIReturnKeyType.done
        searchController.searchBar.tintColor = UIColor.lightGray

        setLoadingScreen()
        DispatchQueue.main.async {
            Database.database().reference().child("users").observe(.value, with: { (snapshot) in
                if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                    self.searchDetail.removeAll()
                    
                    // Checking the user detail
//                    print(snapshot)
                    
                    for data in snapshot {
                        if let postDictionary = data.value as? Dictionary<String, AnyObject> {
                            let key = data.key
                            let post = Search(userKey: key, postData: postDictionary)
//                            print(key)
                            if key == KeychainWrapper.standard.string(forKey: "uid") {
                                continue
                            }
                            self.searchDetail.append(post)
                        }
                    }
                }
                
                self.tableView.reloadData()
                self.removeLoadingScreen()
            })
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // Set the activity indicator into the main view
    private func setLoadingScreen() {
        
        // Sets the view which contains the loading text and the activityIndicator
        let width: CGFloat = 120
        let height: CGFloat = 30
        let x = (tableView.frame.width / 2) - (width / 2)
        let y = (tableView.frame.height / 2) - (height / 2) - (navigationController?.navigationBar.frame.height)!
        loadingView.frame = CGRect(x: x, y: y, width: width, height: height)
        
        // Sets loading text
        loadingLabel.textColor = Theme.current.background//.gray
        loadingLabel.textAlignment = .center
        loadingLabel.text = "Loading..."
        loadingLabel.frame = CGRect(x: 0, y: 0, width: 140, height: 30)
        
        // Sets activityIndicator
        //        activityIndicator.activityIndicatorViewStyle = Theme.current.background//.gray
        activityIndicator.color = Theme.current.background
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        activityIndicator.startAnimating()
        
        // Adds text and activityIndicator to the view
        loadingView.addSubview(activityIndicator)
        loadingView.addSubview(loadingLabel)
        
        tableView.addSubview(loadingView)
        
    }
    
    // Remove the activity indicator from the main view
    private func removeLoadingScreen() {
        
        // Hides and stops the text and the activityIndicator
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        loadingLabel.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the navigation bar on the this view controller
        navigationController?.navigationBar.barTintColor = Theme.current.background
    }
    

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
        let currentCell = tableView.cellForRow(at: indexPath)
        recipientName = (currentCell as! SearchTableViewCell).nameLabel.text!
        performSegue(withIdentifier: "toMessage", sender: nil)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            isSearching = false
            view.endEditing(true)
            tableView.reloadData()
        } else {
            isSearching = true
            filteredData = searchDetail.filter({ $0.username.contains(searchBar.text!.lowercased()) })
            tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? MessageViewController {
            destinationViewController.recipient = recipient
            destinationViewController.messageID = messageID
            destinationViewController.recipientNameNavigationItem.title = recipientName
        }
    }
}
