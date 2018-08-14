//
//  MessageViewController.swift
//  My name is Ivan
//
//  Created by Ivan Rzhanoi on 07/08/2018.
//  Copyright © 2018 Ivan Rzhanoi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import SwiftKeychainWrapper

class MessageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var sendButton: UIButton!
//    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var tableVIew: UITableView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    var messageID: String!
    var messages = [Message]()
    var message: Message!
    var currentUser = KeychainWrapper.standard.string(forKey: "uid")
    var recipient: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableVIew.delegate = self
        tableVIew.dataSource = self
        tableVIew.rowHeight = UITableViewAutomaticDimension
        tableVIew.estimatedRowHeight = 300
        
        if messageID != "" && messageID != nil {
            loadData()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        view.addGestureRecognizer(tap)
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
            self.moveToBottom()
        }
    }
    
    @objc func keyboardWillShow(notify: NSNotification) {
        if let userInfo = notify.userInfo {
            let keyboardFrame = userInfo[UIKeyboardFrameEndUserInfoKey] as? CGRect
                
            UIView.animate(withDuration: 5) {
                self.bottomConstraint.constant = -keyboardFrame!.height
                self.view.layoutIfNeeded()
            }
            
            moveToBottom()
        }
    }
    
    @objc func keyboardWillHide(notify: NSNotification) {
        UIView.animate(withDuration: 5) {
            self.bottomConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        if let cell = tableVIew.dequeueReusableCell(withIdentifier: "Message") as? MessagesTableViewCell {
            cell.configureCell(message: message)
            return cell
        } else {
            return MessagesTableViewCell()
        }
    }
    
    func loadData() {
        Database.database().reference().child("messages").child(messageID).observe(.value, with: { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                self.messages.removeAll()
                for data in snapshot {
                    if let postDictionary = data.value as? Dictionary<String, AnyObject> {
                        let key = data.key
                        let post = Message(messageKey: key, postData: postDictionary)
                        self.messages.append(post)
                    }
                }
            }
            
            self.tableVIew.reloadData()
        })
    }
    
    func moveToBottom() {
        if messages.count > 0 {
            let indexPath = IndexPath(row: messages.count - 1, section: 0)
            tableVIew.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    @IBAction func sendPressed (_ sender: AnyObject) {
//        dismissKeyboard()
//        if (messageTextField.text != nil && messageTextField.text != "") {
        if (messageTextView.text != nil && messageTextView.text != "") {
            if messageID == nil {
                let post: Dictionary<String, AnyObject> = [
//                    "message": messageTextField.text as AnyObject,
                    "message": messageTextView.text as AnyObject,
                    "sender": recipient as AnyObject
                ]
                
                let message: Dictionary<String, AnyObject> = [
//                    "lastMessage": messageTextField.text as AnyObject,
                    "lastMessage": messageTextView.text as AnyObject,
                    "recipient": recipient as AnyObject
                ]
                
                let recipientMessage: Dictionary<String, AnyObject> = [
//                    "lastMessage": messageTextField.text as AnyObject,
                    "lastMessage": messageTextView.text as AnyObject,
                    "recipient": currentUser as AnyObject
                ]
                
                messageID = Database.database().reference().child("messages").childByAutoId().key
                let firebaseMessage = Database.database().reference().child("messages").child(messageID).childByAutoId()
                firebaseMessage.setValue(post)
                
                let recipientMessageDisplay = Database.database().reference().child("users").child(recipient).child("messages").child(messageID)
                recipientMessageDisplay.setValue(recipientMessage)
                
                let userMessage = Database.database().reference().child("users").child(currentUser!).child("messages").child(messageID)
                userMessage.setValue(message)
                
                loadData()
            } else if messageID != "" {
                let post: Dictionary<String, AnyObject> = [
//                    "message": messageTextField.text as AnyObject,
                    "message": messageTextView.text as AnyObject,
                    "sender": recipient as AnyObject
                ]
                
                let message: Dictionary<String, AnyObject> = [
//                    "lastMessage": messageTextField.text as AnyObject,
                    "lastMessage": messageTextView.text as AnyObject,
                    "recipient": recipient as AnyObject
                ]
                
                let recipientMessage: Dictionary<String, AnyObject> = [
//                    "lastMessage": messageTextField.text as AnyObject,
                    "lastMessage": messageTextView.text as AnyObject,
                    "recipient": currentUser as AnyObject
                ]
                
                let firebaseMessage = Database.database().reference().child("messages").child(messageID).childByAutoId()
                firebaseMessage.setValue(post)
                
                let recipientMessageDisplay = Database.database().reference().child("users").child(recipient).child("messages").child(messageID)
                recipientMessageDisplay.setValue(recipientMessage)
                
                let userMessage = Database.database().reference().child("users").child(currentUser!).child("messages").child(messageID)
                userMessage.setValue(message)
                
                loadData()
            }
            
//            messageTextField.text = ""
            messageTextView.text = ""
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
            self.moveToBottom()
        }
    }
}










