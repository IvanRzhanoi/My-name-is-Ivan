//
//  Project.swift
//  My name is Ivan
//
//  Created by Ivan Rzhanoi on 16/07/2018.
//  Copyright © 2018 Ivan Rzhanoi. All rights reserved.
//

import UIKit

class Project {
    // MARK: Properties
    var name: String
    var image: UIImage?
    var description: String
    
    // MARK: Initialization
    init(name: String, image: UIImage?, description: String) {
        // Initialize stored properties.
        self.name = name
        self.image = image
        self.description = description
    }
}
