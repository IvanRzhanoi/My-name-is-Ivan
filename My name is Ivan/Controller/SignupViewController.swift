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
    var emailText: String!
    var passwordText: String!
    var imagePicker: UIImagePickerController!
    var isImageSelected = false
    var username: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        self.view.backgroundColor = Theme.current.background
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            userImageView.image = image
            isImageSelected = true
        } else {
            print("Image wasn't selected")
            displayAlertMessage(messageToDisplay: "Image was not selected")
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func setupUser(imageURL: String) {
        let userData = [
            "username": username!,
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
            displayAlertMessage(messageToDisplay: "An image needs to be selected")
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
                    self.displayAlertMessage(messageToDisplay: "Did not upload the image")
                } else {
                    print("uploaded")
                    storageItem.downloadURL(completion: { (url, error) in
                        if error != nil {
//                            print(error!)
                            self.displayAlertMessage(messageToDisplay: error as! String)
                            return
                        }
                        if url != nil {
                            self.setupUser(imageURL: url!.absoluteString)
                            self.dismiss(animated: true, completion: nil)
                        }
                    })
                }
            }
        }
    }
    
    func displayAlertMessage(messageToDisplay: String) {
        let alertController = UIAlertController(title: "Alert", message: messageToDisplay, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            
            // Code in this block will trigger when OK button tapped.
            print("Ok button tapped");
            
        }
        
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion:nil)
    }
    
    @IBAction func selectImage(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func createAccount(_ sender: Any) {
        Auth.auth().createUser(withEmail: emailText, password: passwordText, completion: { (user, error) in
            if error != nil {
                if let errorCode = AuthErrorCode(rawValue: error!._code) {
                    switch errorCode {
                    case .invalidEmail:
                        self.displayAlertMessage(messageToDisplay: "Invalid email")
                    case .emailAlreadyInUse:
                        self.displayAlertMessage(messageToDisplay: "This email is already in use")
                    default:
                        self.displayAlertMessage(messageToDisplay: "Uknown error creating the user")
                    }
                }
            } else {
                if let user = user {
                    self.userUID = user.user.uid
                    DispatchQueue.main.asyncAfter(deadline: .now() + 10.0, execute: {
                        self.navigationController?.popViewController(animated: true)
                        self.dismiss(animated: true, completion: nil)
                    })
                }
            }

            self.uploadImage()
        })
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
