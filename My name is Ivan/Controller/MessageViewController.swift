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
    
    @IBOutlet weak var recipientNameNavigationItem: UINavigationItem!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var messageTableView: UITableView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    let loadingView = UIView()
    let activityIndicator = UIActivityIndicatorView()
    let loadingLabel = UILabel()
    
    var messageID: String!
    var messages = [Message]()
    var message: Message!
    var currentUser = KeychainWrapper.standard.string(forKey: "uid")
    var recipient: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        messageView.backgroundColor = Theme.current.background
        view.backgroundColor = Theme.current.background
        
        messageTableView.delegate = self
        messageTableView.dataSource = self
        messageTableView.rowHeight = UITableViewAutomaticDimension
        messageTableView.estimatedRowHeight = 300
        
        if messageID != "" && messageID != nil {
            loadData()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // Set the activity indicator into the main view
    private func setLoadingScreen() {
        
        // Sets the view which contains the loading text and the activityIndicator
        let width: CGFloat = 120
        let height: CGFloat = 30
        let x = (messageTableView.frame.width / 2) - (width / 2)
        let y = (messageTableView.frame.height / 2) - (height / 2) - (navigationController?.navigationBar.frame.height)!
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
        
        messageTableView.addSubview(loadingView)
        
    }
    
    // Remove the activity indicator from the main view
    private func removeLoadingScreen() {
        
        // Hides and stops the text and the activityIndicator
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        loadingLabel.isHidden = true
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
        if let cell = messageTableView.dequeueReusableCell(withIdentifier: "Message") as? MessagesTableViewCell {
            cell.configureCell(message: message)
            return cell
        } else {
            return MessagesTableViewCell()
        }
    }
    
    func loadData() {
        setLoadingScreen()
        DispatchQueue.main.async {
            Database.database().reference().child("messages").child(self.messageID).observe(.value, with: { (snapshot) in
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
                
                self.messageTableView.reloadData()
                self.moveToBottom()
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
                    self.removeLoadingScreen()
                }
            })
        }
    }
    
    func moveToBottom() {
        if messages.count > 0 {
            let indexPath = IndexPath(row: messages.count - 1, section: 0)
            messageTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    @IBAction func sendPressed (_ sender: AnyObject) {
        if (messageTextView.text != nil && messageTextView.text != "") {
            if messageID == nil {
                let post: Dictionary<String, AnyObject> = [
                    "message": messageTextView.text as AnyObject,
                    "sender": recipient as AnyObject
                ]
                
                let message: Dictionary<String, AnyObject> = [
                    "lastMessage": messageTextView.text as AnyObject,
                    "recipient": recipient as AnyObject
                ]
                
                let recipientMessage: Dictionary<String, AnyObject> = [
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
                    "message": messageTextView.text as AnyObject,
                    "sender": recipient as AnyObject
                ]
                
                let message: Dictionary<String, AnyObject> = [
                    "lastMessage": messageTextView.text as AnyObject,
                    "recipient": recipient as AnyObject
                ]
                
                let recipientMessage: Dictionary<String, AnyObject> = [
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
            
            messageTextView.text = ""
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
            self.moveToBottom()
        }
    }
}










