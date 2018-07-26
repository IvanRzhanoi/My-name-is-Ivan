//
//  SettingsTableViewController.swift
//  My name is Ivan
//
//  Created by Ivan Rzhanoi on 26/07/2018.
//  Copyright © 2018 Ivan Rzhanoi. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem

        applyTheme()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
//            header.backgroundView?.backgroundColor = UIColor(displayP3Red: 151/255, green: 22/255, blue: 19/255, alpha: 0.0)
//            header.textLabel?.textColor = UIColor.yellow
            
            // Background Color
//            header.backgroundView?.backgroundColor = .clear
//            let blurEffect = UIBlurEffect(style: .extraLight)
//            let blurEffectView = UIVisualEffectView(effect: blurEffect)
//            //always fill the view
//            blurEffectView.frame = (header.backgroundView?.bounds)!//view.bounds
//            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//
//            header.backgroundView?.addSubview(blurEffectView)
            
            // Text Color
            header.textLabel?.textColor = UIColor.white
        }
    }
    
    fileprivate func applyTheme() {
        switch Theme.current.background {
        case UIColor(named: "Dark"):
            segmentedControl.selectedSegmentIndex = 1
        default:
            segmentedControl.selectedSegmentIndex = 0
        }
        
        view.backgroundColor = Theme.current.background
        segmentedControl.tintColor = Theme.current.background

        guard let tabBar = self.tabBarController?.tabBar else { return }
        
//        tabBar.tintColor = UIColor.white
        tabBar.barTintColor = Theme.current.background
//        tabBar.unselectedItemTintColor = UIColor.yellow
    }
    
    @IBAction func themeChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            Theme.current = WhiteStripesTheme()
            UserDefaults.standard.set("WhiteStripesTheme", forKey: "Theme")
        case 1:
            Theme.current = DarkTheme()
            UserDefaults.standard.set("DarkTheme", forKey: "Theme")
        default:
            break
        }
        
        applyTheme()
    }
}
