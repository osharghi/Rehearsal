//
//  LibraryController.swift
//  Rehearsal
//
//  Created by Omid Sharghi on 1/21/19.
//  Copyright © 2019 Omid Sharghi. All rights reserved.
//

import UIKit
import CoreData

class LibraryController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //UITableView
    @IBOutlet weak var tableView: UITableView!
    
    let cellReuseIdentifier = "cell"
    var recordings: [NSManagedObject] = []
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        setUpConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        fetchData()
    }
    
    func fetchData()
    {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //2
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Recording")
        
        //3
        do {
            recordings = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
    }
    
    func setUpConstraints()
    {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        let tableViewBottomAnchor = tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        let tableViewTopAnchor = tableView.topAnchor.constraint(equalTo: self.view.topAnchor)
        let tableViewWidthAnchor = tableView.widthAnchor.constraint(equalTo: self.view.widthAnchor)
        let tableViewHeightAnchor = tableView.heightAnchor.constraint(equalTo: self.view.heightAnchor)
        let tableViewCXAnchor = tableView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        NSLayoutConstraint.activate([tableViewBottomAnchor, tableViewTopAnchor, tableViewWidthAnchor, tableViewHeightAnchor, tableViewCXAnchor])
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.recordings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell!
        
        let recording = recordings[indexPath.row]
        cell.textLabel?.text =
            recording.value(forKey: "title") as? String
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }




}
