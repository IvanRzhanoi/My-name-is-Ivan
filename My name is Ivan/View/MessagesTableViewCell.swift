//
//  MessagesTableViewCell.swift
//  My name is Ivan
//
//  Created by Ivan Rzhanoi on 07/08/2018.
//  Copyright © 2018 Ivan Rzhanoi. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class MessagesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var receivedMessageLabel: UILabel!
    @IBOutlet weak var receivedMessageView: UIView!
    @IBOutlet weak var sentMessageLabel: UILabel!
    @IBOutlet weak var sentMessageView: UIView!
    
    var message: Message!
    var currentUser = KeychainWrapper.standard.string(forKey: "uid")

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureCell(message: Message) {
        self.message = message
        
        // We check if the user is correct
        // TODO: Make the logic logical and show sent messages on the right according to logic
        if message.sender != currentUser {
            sentMessageView.isHidden = false
            sentMessageLabel.text = message.message
            receivedMessageLabel.text = ""
            receivedMessageView.isHidden = true
        } else {
            sentMessageView.isHidden = true
            sentMessageLabel.text = ""
            receivedMessageLabel.text = message.message
            receivedMessageView.isHidden = false
        }
    }
}










