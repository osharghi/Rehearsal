//
//  SongLibraryController.swift
//  Rehearsal
//
//  Created by Omid Sharghi on 2/7/19.
//  Copyright © 2019 Omid Sharghi. All rights reserved.
//

import UIKit
import CoreData

class SaveController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    
    let storageManager = StorageManager()
    let cellReuseIdentifier = "cell"
    var songs: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        setUpAddButton()
        setUpConstraints()
        setUpBackButton()
        fetchSongs()

        if(songs.isEmpty)
        {
            tableView.isHidden = true;
            addNewSong()
        }
        else
        {
            tableView.isHidden = false;
            print("GOT SONGS")
        }
    }
    
    @objc func addNewSong()
    {
        let alertController = UIAlertController(title: "Add New Song", message: "", preferredStyle: .alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "title"
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { action in
            let firstTextField = alertController.textFields![0] as UITextField
            
            if (!(firstTextField.text?.isEmpty)!)
            {
                self.storageManager.saveVersion(title: firstTextField.text!, firstSave: true)
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { (action : UIAlertAction!) -> Void in })
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func setUpAddButton()
    {
        let button = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(SaveController.addNewSong))
        navigationItem.rightBarButtonItem = button
        navigationItem.rightBarButtonItem?.tintColor = .white
    }
    
    func fetchSongs()
    {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Song")
        
        do {
            songs = try managedContext.fetch(fetchRequest)
            
            //Printing for test purposes
            for (_, song) in songs.enumerated() {
                
                let versionSet = song.mutableSetValue(forKey: "versions")
                let title = song.value(forKey: "title") as! String
                print(title)
                
                for (_,version) in versionSet.enumerated(){
                    
                    let url = (version as! NSManagedObject).value(forKey: "url") as! String
                    let num = (version as! NSManagedObject).value(forKey: "num") as! Int
                    print(url)
                    print(num)
                }
                
            }
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func setUpConstraints()
    {
//        tableView.translatesAutoresizingMaskIntoConstraints = false
//        let tableViewBottomAnchor = tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
//        let tableViewTopAnchor = tableView.topAnchor.constraint(equalTo: self.view.topAnchor)
//        let tableViewWidthAnchor = tableView.widthAnchor.constraint(equalTo: self.view.widthAnchor)
//        let tableViewHeightAnchor = tableView.heightAnchor.constraint(equalTo: self.view.heightAnchor)
//        let tableViewCXAnchor = tableView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
//        NSLayoutConstraint.activate([tableViewBottomAnchor, tableViewTopAnchor, tableViewWidthAnchor, tableViewHeightAnchor, tableViewCXAnchor])
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
    }
    
    func setUpBackButton()
    {
        
        let fontSize:CGFloat = 18
        let font:UIFont = UIFont.boldSystemFont(ofSize: fontSize)
        let attributes: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor : UIColor.white,]
        let item = UIBarButtonItem.init(title: "CANCEL", style: .plain, target: self, action: #selector(SaveController.cancelPressed))
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
        addVersionToSong(title: song.value(forKey: "title") as! String)
    }
    
    func addVersionToSong(title: String)
    {
        self.storageManager.saveVersion(title: title, firstSave: false)
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
