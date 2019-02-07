//
//  SongLibraryController.swift
//  Rehearsal
//
//  Created by Omid Sharghi on 2/7/19.
//  Copyright © 2019 Omid Sharghi. All rights reserved.
//

import UIKit
import CoreData

class SongLibraryController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    
    let cellReuseIdentifier = "cell"
    var songs: [NSManagedObject] = []
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        fetchData()
        
        if(songs.isEmpty)
        {
            tableView.isHidden = true;
            addNewSong()
            
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        setUpConstraints()
        setUpBackButton()
    }
    
    func addNewSong()
    {
        
    }
    
    func setUpAddButton()
    {
        let button = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(SongLibraryController.addNewSong))
        navigationItem.rightBarButtonItem = button
    }
    
    func fetchData()
    {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Song")
        
        do {
            songs = try managedContext.fetch(fetchRequest)
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
    
    func setUpBackButton()
    {
        
        let fontSize:CGFloat = 18
        let font:UIFont = UIFont.boldSystemFont(ofSize: fontSize)
        let attributes: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor : UIColor.white,]
        let item = UIBarButtonItem.init(title: "CANCEL", style: .plain, target: self, action: #selector(SongLibraryController.cancelPressed))
        item.setTitleTextAttributes(attributes, for: UIControl.State.normal)
        self.navigationItem.leftBarButtonItem = item
        
    }
    
    @objc func cancelPressed()
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell!
        
        let song = songs[indexPath.row]
        cell.textLabel?.text =
            song.value(forKey: "title") as? String
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let song = songs[indexPath.row]
    }
    
    @objc func addNewSong()
    {
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
