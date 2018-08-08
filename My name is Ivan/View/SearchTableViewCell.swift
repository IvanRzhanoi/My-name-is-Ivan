//
//  SearchTableViewCell.swift
//  My name is Ivan
//
//  Created by Ivan Rzhanoi on 08/08/2018.
//  Copyright © 2018 Ivan Rzhanoi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import SwiftKeychainWrapper

class SearchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var searchDetail: Search!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(searchDetail: Search) {
        self.searchDetail = searchDetail
        nameLabel.text = searchDetail.username
        let reference = Storage.storage().reference(forURL: searchDetail.userImage)
        reference.getData(maxSize: 1000000, completion: { (data, error) in
            if error != nil {
                print("We couldn't download the image")
            } else {
                if let imageData = data {
                    if let image = UIImage(data: imageData) {
                        self.userImageView?.image = image
                    }
                }
            }
        })
    }

}












