//
//  LibraryController.swift
//  Rehearsal
//
//  Created by Omid Sharghi on 1/21/19.
//  Copyright © 2019 Omid Sharghi. All rights reserved.
//

import UIKit

class LibraryController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //UITableView
    @IBOutlet weak var tableView: UITableView!
    
    let tracks: [String] = ["Track1", "Track2", "Track3", "Track4", "Track5"]
    let cellReuseIdentifier = "cell"
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        setUpConstraints()
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
        return self.tracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell!
        
        // set the text from the data model
        cell.textLabel?.text = self.tracks[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }




}
