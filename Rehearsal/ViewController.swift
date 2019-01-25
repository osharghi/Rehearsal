//
//  ViewController.swift
//  Rehearsal
//
//  Created by Omid Sharghi on 1/5/19.
//  Copyright © 2019 Omid Sharghi. All rights reserved.
//

import UIKit
import AVFoundation
import CoreData

class ViewController: UIViewController, AVAudioRecorderDelegate {
    
    enum State {
        case down
        case up
    }
    
    var position = State.down
    
    //UI
    var slideView : UIView!
    var label : UILabel!
    
    //Constraints
    var slideViewBottomAnchor : NSLayoutConstraint!
    var labelBottomAnchor: NSLayoutConstraint!

    //AudioRecorder
    var recorder : AVAudioRecorder!
    var recordingSession : AVAudioSession!
    
    //AudioPlayer
    var player : AVAudioPlayer?
    var currentRecorderURL : URL?
    var currentPlayerURL : URL?
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 107/255, green: 212/255, blue: 231/255, alpha: 1)
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.view.backgroundColor = UIColor(red: 27/255, green: 53/255, blue: 58/255, alpha: 1)
        
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()
        setUpSlideView()
        setUpLabel()
        setUpRecognizer()
        setUpRecorder()
        setUpRightButton()
        checkFiles()
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        let counter = UserDefaults.standard.integer(forKey: "Counter")
        print(counter)
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Recording")
        
        var recordings: [NSManagedObject] = []
        do {
            recordings = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        if recordings.count > 0
        {
            let recording = recordings[0]
            let title = recording.value(forKey: "title") as? String
            print(title!)
        }
    }
    
    //Test Fuction
    func checkFiles()
    {
        do{
        let directory = getDocumentsDirectory()
        let directoryContents = try FileManager.default.contentsOfDirectory(at: directory, includingPropertiesForKeys: nil, options: [])
            print(directoryContents)
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    func setUpRecorder()
    {
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission(){ [weak self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        //do nothing
                        print("Enabled")
                    }
                    else{
                        //Handle error messsage
                        print("Not enabled")
                    }
                }
            }
        } catch {
            //Handle error
            print("Failed to access audio session.")
        }
    }
    
    func startRecording()
    {
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            recorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            recorder.delegate = self
            recorder.record()
            
        } catch {
            stopRecording(success: false)
        }
    }
    
    func stopRecording(success: Bool)
    {
        recorder.stop()
//        audioRecorder = nil
        
        if success {
            currentRecorderURL = recorder.url
        } else {
            //doSomething
        }
    }
    
    func getDocumentsDirectory() -> URL
    {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    
    func setUpSlideView()
    {
        let slideView = UIView()
        slideView.backgroundColor = UIColor(red: 107/255, green: 212/255, blue: 231/255, alpha: 1)
        self.view.addSubview(slideView)
        slideView.translatesAutoresizingMaskIntoConstraints = false

        
        let cxAnchor = slideView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        let bAnchor = slideView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        let wAnchor = slideView.widthAnchor.constraint(equalToConstant: self.view.bounds.width)
        let hAnchor = slideView.heightAnchor.constraint(equalToConstant: self.view.bounds.height)

        slideViewBottomAnchor = bAnchor
        
        NSLayoutConstraint.activate([wAnchor, hAnchor, cxAnchor, bAnchor])
        self.slideView = slideView
    }
    
    func setUpRecognizer()
    {
        let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.handleUpSwipe))
        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.handleDownSwipe))
        let tapRec = UITapGestureRecognizer(target: self, action: #selector(ViewController.handleTap))
        
        self.slideView.addGestureRecognizer(upSwipe)
        self.slideView.addGestureRecognizer(downSwipe)
        self.slideView.addGestureRecognizer(tapRec)
        self.slideView.isUserInteractionEnabled = true

        upSwipe.direction = .up
        downSwipe.direction = .down
        
    }
    
    func setUpLabel()
    {
        let label = UILabel()
        label.text = "TEST"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20.0)
        self.view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let labelCXAnchor = label.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        let labelBottomAnchor = label.bottomAnchor.constraint(equalTo:self.slideView.bottomAnchor, constant: -self.view.frame.height/2)
        self.labelBottomAnchor = labelBottomAnchor
        
        NSLayoutConstraint.activate([labelCXAnchor, self.labelBottomAnchor])
        self.label = label
    }
    
    func setUpRightButton()
    {
        
        let fontSize:CGFloat = 18
        let font:UIFont = UIFont.boldSystemFont(ofSize: fontSize)
        let attributes: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor : UIColor.white,]
        let item = UIBarButtonItem.init(title: "Save", style: .plain, target: self, action: #selector(ViewController.savePressed))
        item.setTitleTextAttributes(attributes, for: UIControl.State.normal)
        self.navigationItem.rightBarButtonItem = item;
    }
    
    func animateUp()
    {
        if(position == State.down)
        {
            self.slideViewBottomAnchor.constant -= 250
            self.labelBottomAnchor.constant += 200
            UIView.animate(withDuration: 1) {
                self.view.layoutIfNeeded()
            }
            position = State.up
            startRecording()
        }
    }
    
    func animateDown()
    {
        if(position == State.up)
        {
            self.slideViewBottomAnchor.constant += 250
            self.labelBottomAnchor.constant -= 200
            UIView.animate(withDuration: 1) {
                self.view.layoutIfNeeded()
            }
            position = State.down
            stopRecording(success: true)
        }
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            stopRecording(success: false)
        }
    }
    
    @objc func handleTap()
    {
        print("tapped")
        
        if(position == State.down)
        {
            if let player = self.player
            {
                if(player.isPlaying)
                {
                    player.pause()
                }
                else if(currentRecorderURL == currentPlayerURL)
                {
                    player.play()
                }
                else
                {
                    if let urlToPlay = self.currentRecorderURL
                    {
                        play(fileURL: urlToPlay)
                    }
                    else
                    {
                        print("No file")
                    }
                }
            }
            else
            {
                if let urlToPlay = self.currentRecorderURL
                {
                    play(fileURL: urlToPlay)
                }
                else
                {
                    print("No File")
                }
            }
        }
    }
    
    func play(fileURL: URL)
    {
        do {
            self.currentPlayerURL = fileURL
            self.player = try AVAudioPlayer(contentsOf: fileURL)
            self.player?.play()
            
        } catch {
            // couldn't load file :(
        }
    }
    
    @objc func handleUpSwipe()
    {
        animateUp()
    }
    
    @objc func handleDownSwipe()
    {
        animateDown()
    }
    
    @objc func savePressed()
    {
        let success = prepareRecordingFile()
        if success == true
        {
            performSegue(withIdentifier: "ToLibrary", sender: self)
        }
        else{
            //Display error
        }
    }
    
    func prepareRecordingFile() -> Bool
    {
        do {
            let counter = UserDefaults.standard.integer(forKey: "Counter")
            let directoryURL = getDocumentsDirectory()
            let originPath = directoryURL.appendingPathComponent("recording.m4a")
            let recordingTitle = "Track-" + String(counter)
            let pathTitle = recordingTitle + ".m4a"
            let destinationPath = directoryURL.appendingPathComponent(pathTitle)
            try FileManager.default.moveItem(at: originPath, to: destinationPath)
            
            let saved = saveRecording(title: recordingTitle, url: destinationPath)
            if saved != true
            {
                //Handle error
                return false;
            }
            
        } catch {
            print(error)
            return false
        }
        
        return true
    }
    
    func updateCounter()
    {
        var counter = UserDefaults.standard.integer(forKey: "Counter")
        counter += 1
        UserDefaults.standard.set(counter, forKey:"Counter")
    }
    
    func saveRecording(title: String, url: URL) -> Bool
    {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return false
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Recording",
                                       in: managedContext)!
        
        let recording = NSManagedObject(entity: entity, insertInto: managedContext)
        
        recording.setValue(title, forKey: "title")
        recording.setValue(url.absoluteString, forKey: "url")
        
        do {
            try managedContext.save()
            print("SAVE SUCCESSFUL")
            updateCounter()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            return false
        }
        
        return true
        
    }
    
}

