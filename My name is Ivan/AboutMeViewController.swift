//
//  AboutMeViewController.swift
//  My name is Ivan
//
//  Created by Ivan Rzhanoi on 17/07/2018.
//  Copyright © 2018 Ivan Rzhanoi. All rights reserved.
//

import UIKit

class AboutMeViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
//    @IBOutlet weak var picture1: UIImageView!
    @IBOutlet weak var picture1: UIView!
    @IBOutlet weak var picture2: UIView!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Change the color of tabBar on launch. Since this is the first page encountered on app-load,
        // we need to load it only on this ViewController
        guard let tabBar = self.tabBarController?.tabBar else { return }
        tabBar.barTintColor = Theme.current.background
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        view.backgroundColor = Theme.current.background
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let imageFrame1 = UIBezierPath(rect: picture1.frame)
        let imageFrame2 = UIBezierPath(rect: picture2.frame)
        textView.textContainer.exclusionPaths = [imageFrame1, imageFrame2]
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
