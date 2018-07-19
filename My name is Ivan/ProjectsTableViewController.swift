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
        let project1 = Project(name: "MusicMood", image: #imageLiteral(resourceName: "MusicMood"), description: "An application that plays music depending on user's feelings\n\nFeelings are determined through the use of brainwaves, which are acquired with MUSE Headband. The app has been written in Swift with API in Objective-c, which is provided by \"Interaxon Inc.\", the creators of brainsensing headband\n\n\n\nIt took half a year of development time with most of the it being dedicated towards fixing bugs. The app is not yet published due to licecnsing issues with the company providing the API for the equipment\n\n\nFor more information on project please check\n\nhttp://urn.fi/URN:NBN:fi:amk-2018060512587")
        let project2 = Project(name: "Optimov", image: #imageLiteral(resourceName: "Optimov"), description: "An online-based service that helps patients rehabilitate\n\nOptimov is a start-up, which offers a variety of services related to healthcare, mostly physiotherapy. It is going to be steadily integrated in hospitals to ease doctors’ work. Doctor will be able to assign their patients some training and track their health as well as general performance\n\nI was responsible for the free iOS version of an app, which is being used for demonstrative purposes as of writing. It was made with Swift and embedded Unity. Unity part was already made for Android. I also had to alter some C# code on Unity script. The greatest challenge was to make Unity load with the corresponding ViewController as it automatically loads with the whole application\n\nI also made some script to make server calls and update the user's infromation using JSON and Core Data. The app has a questionnaire section, to which the patient has to answer. The code picks exercises based on patient's performance, it then assembles the JSON string and sends it to Unity part, which plays the exercises. On top of that, I have found and fixed a few issues within the PHP code on the server side. Finally, I managed the beta version through iTunes Connect\n\nFor more information on project please check\n\nhttps://optimov.com")
        
        
        let project5 = Project(name: "This list is incomplete", image: nil, description: "I didn't finish explaining all the projects I have done. Please be patient...")
        
        projects += [project1, project2, project5]
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
