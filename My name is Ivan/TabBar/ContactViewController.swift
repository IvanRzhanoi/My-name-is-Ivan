//
//  ContactViewController.swift
//  My name is Ivan
//
//  Created by Ivan Rzhanoi on 15/07/2018.
//  Copyright © 2018 Ivan Rzhanoi. All rights reserved.
//

import UIKit
import MessageUI

class ContactViewController: UIViewController, MFMailComposeViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        view.backgroundColor = Theme.current.background
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self as MFMailComposeViewControllerDelegate // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients(["Ivan.Rzhanoi@gmail.com"])
        mailComposerVC.setSubject("Hello, ")
        mailComposerVC.setMessageBody("", isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertController(title: "Could Not Send Email", message: "Please check your connection and try again", preferredStyle: UIAlertControllerStyle.alert)
        let dismiss = UIAlertAction(title: "Ok", style: .default, handler: nil)
        sendMailErrorAlert.addAction(dismiss)
        self.present(sendMailErrorAlert, animated: true, completion: nil)
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func linkedInButton(_ sender: Any) {
        UIApplication.shared.open(URL(string : "https://www.linkedin.com/in/ivan-rzhanoi/")!, options: [:], completionHandler: { (status) in })
    }
    
    @IBAction func twitterButton(_ sender: Any) {
        UIApplication.shared.open(URL(string : "https://twitter.com/Mister_IRz")!, options: [:], completionHandler: { (status) in })
    }
    
    @IBAction func facebookButton(_ sender: Any) {
        UIApplication.shared.open(URL(string : "https://www.facebook.com/Ivan.Rzhanoi")!, options: [:], completionHandler: { (status) in })
    }
    
    @IBAction func githubButton(_ sender: Any) {
        UIApplication.shared.open(URL(string : "https://github.com/IvanRzhanoi")!, options: [:], completionHandler: { (status) in })
    }
    
    @IBAction func websiteButton(_ sender: Any) {
        UIApplication.shared.open(URL(string : "http://ivanrz.com")!, options: [:], completionHandler: { (status) in })
    }
    
    @IBAction func sendEmailButtonTapped(sender: AnyObject) {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    @IBAction func icons8Button(_ sender: Any) {
        UIApplication.shared.open(URL(string : "https://icons8.com")!, options: [:], completionHandler: { (status) in })
    }
    
    @IBAction func soomroButton(_ sender: Any) {
        UIApplication.shared.open(URL(string : "https://www.linkedin.com/in/basit-soomro/")!, options: [:], completionHandler: { (status) in })
    }
}
