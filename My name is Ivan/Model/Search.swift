//
//  Search.swift
//  My name is Ivan
//
//  Created by Ivan Rzhanoi on 08/08/2018.
//  Copyright © 2018 Ivan Rzhanoi. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import SwiftKeychainWrapper

class Search {
    private var _username: String!
    private var _userImage: String!
    private var _userKey: String!
    private var _userReference: DatabaseReference!
    var currentUser = KeychainWrapper.standard.string(forKey: "uid")
    
    var username: String {
        return _username
    }
    
    var userImage: String {
        return _userImage
    }
    
    var userKey: String {
        return _userKey
    }
    
    init(username: String, userImageURL: String) {
        _username = username
        _userImage = userImage
    }
    
    init(userKey: String, postData: Dictionary<String, AnyObject>) {
        
        _userKey = userKey
        
        if let username = postData["username"] as? String {
            _username = username
        }
        
        if let userImage = postData["userImage"] as? String {
            _userImage = userImage
        }
        
        _userReference = Database.database().reference().child("messages").child(_userKey)
    }
}







