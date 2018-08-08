//
//  SearchViewController.swift
//  My name is Ivan
//
//  Created by Ivan Rzhanoi on 08/08/2018.
//  Copyright © 2018 Ivan Rzhanoi. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var searchDetail = [Search]()
    var filteredData = [Search]()
    var isSearching = false
    var detail: Search!
    var recipient: String!
    var messageID: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done
        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? MessageViewController {
            destinationViewController.recipient = recipient
            destinationViewController.messageID = messageID
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return filteredData.count
        } else {
            return searchDetail.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
            filteredData = searchDetail.filter({ $0.username == searchBar.text! })
            tableView.reloadData()
        }
    }
    
    @IBAction func goBack(_ sender: AnyObject) {
//        dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
}
