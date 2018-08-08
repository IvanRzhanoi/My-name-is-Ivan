//
//  MessageDetail.swift
//  My name is Ivan
//
//  Created by Ivan Rzhanoi on 07/08/2018.
//  Copyright © 2018 Ivan Rzhanoi. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import SwiftKeychainWrapper

class MessageDetail {
    private var _recipient: String!
    private var _messageKey: String!
    private var _messageReference: DatabaseReference!
    var currentUser = KeychainWrapper.standard.string(forKey: "uid")
    
    var recipient: String {
        return _recipient
    }
    
    var messageKey: String {
        return _messageKey
    }
    
    var messageReference: DatabaseReference {
        return _messageReference
    }
    
    init(recipient: String) {
        _recipient = recipient
    }
    
    init(messageKey: String, messageData: Dictionary<String, AnyObject>) {
        _messageKey = messageKey
        
        if let recipient = messageData["recipient"] as? String {
            _recipient = recipient
        }
        
        _messageReference = Database.database().reference().child("recipient").child(_messageKey)
    }
}
