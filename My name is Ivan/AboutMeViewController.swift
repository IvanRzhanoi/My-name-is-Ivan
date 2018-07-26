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

        // Do any additional setup after loading the view.
        let imageFrame1 = UIBezierPath(rect: picture1.frame)
        let imageFrame2 = UIBezierPath(rect: picture2.frame)
        textView.textContainer.exclusionPaths = [imageFrame1, imageFrame2]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        view.backgroundColor = Theme.current.background
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
