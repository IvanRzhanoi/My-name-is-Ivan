//
//  LoginViewController.swift
//  My name is Ivan
//
//  Created by Ivan Rzhanoi on 06/08/2018.
//  Copyright © 2018 Ivan Rzhanoi. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var userUID: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        if let _ = KeychainWrapper.standard.string(forKey: "uid") {
            performSegue(withIdentifier: "toMessages", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSignUp" {
            if let destination = segue.destination as? SignupViewController {
                if self.userUID != nil {
                    destination.userUID = userUID
                }
                
                if self.emailTextField.text != nil {
                    destination.emailTextField = emailTextField.text
                }
                
                if self.passwordTextField != nil {
                    destination.passwordTextField = passwordTextField.text
                }
            }
        }
    }

    @IBAction func signIn(_ sender: Any) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                if error == nil {
                    self.userUID = user?.user.uid
                    
                    KeychainWrapper.standard.set(self.userUID, forKey: "uid")
                    
                    self.performSegue(withIdentifier: "toMessages", sender: nil)
                } else {
                    self.performSegue(withIdentifier: "toSignUp", sender: nil)
                }
            })
        }
    }
}
