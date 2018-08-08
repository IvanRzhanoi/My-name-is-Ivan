//
//  MessageDetailTableViewCell.swift
//  My name is Ivan
//
//  Created by Ivan Rzhanoi on 07/08/2018.
//  Copyright © 2018 Ivan Rzhanoi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase
import SwiftKeychainWrapper

class MessageDetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var recipientImage: UIImageView!
    @IBOutlet weak var recipientName: UILabel!
    @IBOutlet weak var chatPreview: UILabel!
    
    var messageDetail: MessageDetail!
    var userPostKey: DatabaseReference!
    let currentUser = KeychainWrapper.standard.string(forKey: "uid")

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureCell(messageDetail: MessageDetail) {
        self.messageDetail = messageDetail
        
        let recipientData = Database.database().reference().child("users").child(messageDetail.recipient)
        recipientData.observeSingleEvent(of: .value, with: { (snapshot) in
            let data = snapshot.value as! Dictionary<String, AnyObject>
            let username = data["username"]
            let userImage = data["userImage"]
            self.recipientName.text = username as? String
            let reference = Storage.storage().reference(forURL: userImage as! String)
            reference.getData(maxSize: 100000, completion: { (data, error) in
                if error != nil {
                    print("could not load image")
                } else {
                    if let imageData = data {
                        if let image = UIImage(data: imageData) {
                            self.recipientImage.image = image
                        }
                    }
                }
            })
        })
    }
}






