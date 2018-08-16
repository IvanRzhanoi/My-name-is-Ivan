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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        view.backgroundColor = Theme.current.background
        
        tableView.reloadData()
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
        let project3 = Project(name: "Untitled game", image: #imageLiteral(resourceName: "Game"), description: "A very simple platformer with innovative touch controls. Unfnfinsihed\n\nThe project was conceived during Junction 2017 (Helsinki). In this game the player would control a little fox character using only the gestures. The problem with most platfromers on the phone is that they utilize two virtual thumbsticks, making it impossible to play one handed. We needed to circumvent this problem by greatly simplifying the gaming process. For example, the shooting would be atomatic.\n\nThe game was made in Unity for iOS as a test platform. I did the level design and some of the scripting in C#, although the span of three days was not enough to finish this project. It will be continued at a later date\n\nFor more information on project please check\n\nhttps://github.com/EarthModule/FoxForceFiveJunction2017")
        let project4 = Project(name: "Q-project", image: #imageLiteral(resourceName: "Qproject"), description: "An applications similar to Amazon Alexa and Google Echo, but with Cozify hub\n\nProject was done for Junction 2015. I was responsible for the side of hub. Cozify hub was acting as a server written in plain Python. Cozify hub was listening to the commands coming from the PC. The PC side of program was written in Java\n\nUsers could play the song or turn on the light using their voice commands. It was chosen to stop the development due to other more superior projects offered by companies such as Google, Amazon and Apple\n\nFor more information on project please check\n\nhttps://github.com/IvanRzhanoi/q-project")
        let project5 = Project(name: "MariVision", image: #imageLiteral(resourceName: "MariVision"), description: "Concept work done for Marimekko Designathon 2017. An augumented reality mirror\n\nWe tried to create something that could promote Marimekko brand through its lifestyle, colors and patterns. Originally it was supposed to be an app to help designers pick colors and create 3D sketches of clothes using an augumented reality.\n\nHowever, later the concept was transformed to MariMirror, a form of advertisement. Now we have transparent screens, so the idea was to create interactive mirrors. The potential customer would pass by the storefront of marimekko shop or wait at the bus stop and see themselves in new clothing that is offered by Marimekko\n\nFor more information on project please check\n\nhttps://github.com/IvanRzhanoi/Marimekko_design")
        let project6 = Project(name: "Personal Rental Car", image: #imageLiteral(resourceName: "PRC"), description: "Concept made for the company during Global Project based Learning within Shibaura Institute of Technology\n\nWe wanted to suggest some novel concept for Japan and it was peer-to-peer car sharing similar to Getaround. Users would rent cars not from the company, but from ordinary people. As such rentees would get lower rates, while renters would be able to use their underutilised transport and get an additional income\n\nAdditional project info will be added later")
        let project7 = Project(name: "Bicycle Renting Concept", image: #imageLiteral(resourceName: "BicycleRent"), description: "A small concept work done for JA Challenge 2015 in Vaasa, Finland.\n\nThe goal of this challenge was to create new infrastructure for the city of Vaasa with the goal of either improving the living or attracting the tourists. We worked on a concept of bike renting similar to one in the city of Copenhagen, Denmark. The bikes would be absolutely free for everybody and be used as an alternative to usual public transport, since they have elctric motors that can ease the travel throughout the city\n\nUnfortunately, the information on this project has been lost")
        
        projects += [project1, project2, project3, project4, project5, project6, project7]
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
        
        cell.projectView.backgroundColor = Theme.current.background
        
        return cell
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? ProjectsTableViewCell, let projectDetailViewController = segue.destination as? ProjectDetailViewController {
            projectDetailViewController.projectDescriptionString = cell.projectDescription.text
            projectDetailViewController.projectImage = cell.projectImage.image
        }
    }
}
