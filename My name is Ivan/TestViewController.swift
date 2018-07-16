//
//  TestViewController.swift
//  My name is Ivan
//
//  Created by Ivan Rzhanoi on 16/07/2018.
//  Copyright © 2018 Ivan Rzhanoi. All rights reserved.
//

import UIKit
import Hero

class TestViewController: UIViewController {

    @IBOutlet weak var projectImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        self.isHeroEnabled = true
//        projectImage.heroID = "TheImage"
//        whiteView.hero.modifiers = [.translate(y:100)]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func handlePanGesture(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            dismiss(animated: true, completion: nil)
        case .changed:
            let translation = sender.translation(in: nil)
            let progress = translation.y / 2 / view.bounds.height
            Hero.shared.update(progress: Double(progress))
        default:
            Hero.shared.end()
        }
    }
}
