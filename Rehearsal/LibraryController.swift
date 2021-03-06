//
//  LibraryController.swift
//  Rehearsal
//
//  Created by Omid Sharghi on 1/21/19.
//  Copyright © 2019 Omid Sharghi. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation

class LibraryController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //UITableView
    @IBOutlet weak var tableView: UITableView!
    
    let cellReuseIdentifier = "cell"
    var recordings: [NSManagedObject] = []
    
    //AudioPlayer
    var player : AVAudioPlayer?
    var currentRowPlaying : Int?

    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        setUpConstraints()
        setUpBackButton()
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
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Recording")
        
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
        
        let cell: UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell!
        
        let recording = recordings[indexPath.row]
        cell.textLabel?.text =
            recording.value(forKey: "title") as? String
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let recording = recordings[indexPath.row]
        let urlString = recording.value(forKey: "url") as? String
        var documentPath = getDocumentsDirectory()
        documentPath.appendPathComponent(urlString!)
        let fileURL = documentPath
//        let fileURL = URL(string: urlString!)
                
        if let player = self.player
        {
            if player.isPlaying
            {
                if(indexPath.row == currentRowPlaying)
                {
                    self.player?.pause()
                }
                else
                {
                    play(urlToPlay:fileURL, currentRow: indexPath.row)
                }
            }
            else if self.currentRowPlaying == indexPath.row
            {
                player.play()
            }
            else
            {
                play(urlToPlay:fileURL, currentRow: indexPath.row) //Is this ever called?
            }
        }
        else
        {
            play(urlToPlay:fileURL, currentRow: indexPath.row)
        }
    }
    
    func play(urlToPlay: URL, currentRow: Int)
    {
        do {
            self.currentRowPlaying = currentRow
            self.player = try AVAudioPlayer(contentsOf: urlToPlay)
            self.player?.play()
        } catch {
            // couldn't load file :(
        }
    }
    
    func getDocumentsDirectory() -> URL
    {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func setUpBackButton()
    {
        
        let fontSize:CGFloat = 18
        let font:UIFont = UIFont.boldSystemFont(ofSize: fontSize)
        let attributes: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor : UIColor.white,]
        let item = UIBarButtonItem.init(title: "BACK", style: .plain, target: self, action: #selector(LibraryController.backPressed))
        item.setTitleTextAttributes(attributes, for: UIControl.State.normal)
        self.navigationItem.leftBarButtonItem = item
        
    }
    
    @objc func backPressed()
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
}
