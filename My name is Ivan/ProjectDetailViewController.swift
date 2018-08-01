//
//  ProjectDetailViewController.swift
//  My name is Ivan
//
//  Created by Ivan Rzhanoi on 16/07/2018.
//  Copyright © 2018 Ivan Rzhanoi. All rights reserved.
//

import UIKit
import Hero

class ProjectDetailViewController: UIViewController {

    @IBOutlet weak var projectImageView: UIImageView!
//    @IBOutlet weak var projectDescription: UILabel!
    @IBOutlet weak var projectDescription: UITextView!
    @IBOutlet weak var backButton: UIButton!
    
    var projectImage: UIImage?
    var projectDescriptionString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        backButton.heroModifiers = [.translate(x:-100), .duration(0.5)]
        if let image = projectImage {
            projectImageView.image = image
        }
        
        if let projectDescriptionString = projectDescriptionString {
            projectDescription.text = projectDescriptionString
        }
        
        backButton.layer.shadowOffset = CGSize(width: 5, height: 5)
        backButton.layer.shadowRadius = 5
        backButton.layer.shadowOpacity = 0.5
        
        view.backgroundColor = Theme.current.background
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        UIApplication.shared.open(URL, options: [:])
        return false
    }
    
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .lightContent
//    }

    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func handleScreenEdgePan(_ sender: UIScreenEdgePanGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func handlePanGesture(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: nil)
        let progress = translation.y / 2 / view.bounds.height
        
        switch sender.state {
        case .began:
            dismiss(animated: true, completion: nil)
            print("LOL")
        case .changed:
            Hero.shared.update(progress: Double(progress))
            
            let currentPosition = CGPoint(x: translation.x + projectImageView.center.x, y: translation.y + projectImageView.center.y)
            Hero.shared.temporarilySet(view: projectImageView, modifiers: [.position(currentPosition)])
        default:
            if progress + sender.velocity(in: nil).y / view.bounds.height > 15 {
                Hero.shared.end()
            } else {
                Hero.shared.cancel()
            }
            print("LOLZ")
        }
    }
}
