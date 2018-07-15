//
//  ProjectDetailViewController.swift
//  My name is Ivan
//
//  Created by Ivan Rzhanoi on 16/07/2018.
//  Copyright © 2018 Ivan Rzhanoi. All rights reserved.
//

import UIKit

class ProjectDetailViewController: UIViewController {

    @IBOutlet weak var projectImageView: UIImageView!
    @IBOutlet weak var projectDescription: UILabel!
    
    var projectImage: UIImage?
    var projectDescriptionString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let image = projectImage {
            projectImageView.image = image
        }
        
        if let projectDescriptionString = projectDescriptionString {
            projectDescription.text = projectDescriptionString
        }
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
