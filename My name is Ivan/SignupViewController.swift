//
//  SignupViewController.swift
//  My name is Ivan
//
//  Created by Ivan Rzhanoi on 06/08/2018.
//  Copyright © 2018 Ivan Rzhanoi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import SwiftKeychainWrapper

class SignupViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    
    var userUID: String!
    var emailTextField: String!
    var passwordTextField: String!
    var imagePicker: UIImagePickerController!
    var isImageSelected = false
    var username: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if let _ = KeychainWrapper.standard.string(forKey: "uid") {
            performSegue(withIdentifier: "toMessages", sender: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            userImageView.image = image
            isImageSelected = true
        } else {
            print("image wasn't selected")
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func setupUser(imageURL: String) {
        let userData = [
            "username": username,
            "userImage": imageURL
        ]
        
        KeychainWrapper.standard.set(userUID, forKey: "uid")
        let location = Database.database().reference().child("users").child(userUID)
        location.setValue(userData)
        dismiss(animated: true, completion: nil)
    }
    
    func uploadImage() {
        if userTextField.text == nil {
            signupButton.isEnabled = false
        } else {
            username = userTextField.text
            signupButton.isEnabled = true
        }
        
        guard let image = userImageView.image, isImageSelected == true else {
            print("Image needs to be selected")
            return
        }
        
        if let imageData = UIImageJPEGRepresentation(image, 0.4) {
            let imageUID = NSUUID().uuidString
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            let storageItem = Storage.storage().reference().child(imageUID)
            storageItem.putData(imageData, metadata: metadata) { (metadata, error) in
                if error != nil {
                    print("did not upload image")
                } else {
                    print("uploaded")
                    storageItem.downloadURL(completion: { (url, error) in
                        if error != nil {
                            print(error!)
                            return
                        }
                        if url != nil {
                            self.setupUser(imageURL: url!.absoluteString)
                        }
                    })
                }
            }
        }
    }
    
    @IBAction func selectImage(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func createAccount(_ sender: Any) {
        Auth.auth().createUser(withEmail: emailTextField, password: passwordTextField, completion: { (user, error) in
            if error != nil {
                print("Can't create user")
                print("\(String(describing: error))")
            } else {
                if let user = user {
                    self.userUID = user.user.uid
                }
            }

            self.uploadImage()
        })
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
