//
//  ProjectsTableViewController.swift
//  My name is Ivan
//
//  Created by Ivan Rzhanoi on 15/07/2018.
//  Copyright © 2018 Ivan Rzhanoi. All rights reserved.
//

import UIKit

class ProjectsTableViewController: UITableViewController {

    //MARK: Properties
    
    var projects = [Project]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadProjects()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
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
        return projects.count
    }
    
    private func loadProjects() {
        let project1 = Project(name: "MusicMood", image: #imageLiteral(resourceName: "MusicMoodScreenShot"), description: "A unique application to play music depdnding on user's feelings") // else { fatalError("Unable to load") }
        let project2 = Project(name: "Optimov", image: #imageLiteral(resourceName: "Optimov"), description: "An online-based service with mobile apps that helps patients rehabilitate. Later will be integrated in hospitals to ease doctors’ work. An online-based service with mobile apps that helps patients rehabilitate. Later will be integrated in hospitals to ease doctors’ work.An online-based service with mobile apps that helps patients rehabilitate. Later will be integrated in hospitals to ease doctors’ work.An online-based service with mobile apps that helps patients rehabilitate. Later will be integrated in hospitals to ease doctors’ work.An online-based service with mobile apps that helps patients rehabilitate. Later will be integrated in hospitals to ease doctors’ work.An online-based service with mobile apps that helps patients rehabilitate. Later will be integrated in hospitals to ease doctors’ work.An online-based service with mobile apps that helps patients rehabilitate. Later will be integrated in hospitals to ease doctors’ work.An online-based service with mobile apps that helps patients rehabilitate. Later will be integrated in hospitals to ease doctors’ work.")
        
        projects += [project1, project2]
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Configure the cell
        let cellIdentifier = "ProjectTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ProjectsTableViewCell  else {
            fatalError("The dequeued cell is not an instance of ProjectTableViewCell.")
        }
        
        let project = projects[indexPath.row]
        cell.projectName.text = project.name
        cell.projectImage.image = project.image
        cell.projectDescription.text = project.description
        
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? ProjectsTableViewCell, let projectDetailViewController = segue.destination as? ProjectDetailViewController {
            projectDetailViewController.projectDescriptionString = cell.projectDescription.text
            projectDetailViewController.projectImage = cell.projectImage.image
        }
    }
}
