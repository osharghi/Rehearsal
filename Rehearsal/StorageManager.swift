//
//  StorageManager.swift
//  Rehearsal
//
//  Created by Omid Sharghi on 2/7/19.
//  Copyright © 2019 Omid Sharghi. All rights reserved.
//

import Foundation
import CoreData
import UIKit
class StorageManager
{
    func saveVersion(title: String, firstSave: Bool)
    {
        let pathComponent = saveFilePath()
        var continueSave = true
        if(firstSave)
        {
            continueSave = saveSongToModel(title: title)
        }
        
        if let pathComp = pathComponent
        {
            if(continueSave)
            {
                saveVersionToModel(pathComponent: pathComp, songTitle: title)
                updateCounter()
            }
        }
    }
    
    func saveFilePath() -> String?
    {
        var pathComponent : String?  = nil
        
        do
        {
            let counter = UserDefaults.standard.integer(forKey: "Counter")
            let directoryURL = getDocumentsDirectory()
            let originPath = directoryURL.appendingPathComponent("recording.m4a")
            let defaultTitle = "Track-" + String(counter)
            let pathTitle = defaultTitle + ".m4a"
            let destinationPath = directoryURL.appendingPathComponent(pathTitle)
            try FileManager.default.moveItem(at: originPath, to: destinationPath)
            pathComponent = pathTitle
        }
        catch {
            //Handle Error
            print(error)
            return nil
        }
        
        return pathComponent
    }
    
    func getDocumentsDirectory() -> URL
    {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func saveSongToModel(title: String) -> Bool
    {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return false
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Song",
                                                in: managedContext)!
        
        let song = NSManagedObject(entity: entity, insertInto: managedContext)
        
        song.setValue(title, forKey: "title")
        song.setValue(0, forKey: "index")
        
        do {
            try managedContext.save()
            print("SAVE SUCCESSFUL")
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            return false
        }
        
        return true
    }
    
    func saveVersionToModel(pathComponent: String, songTitle: String)
    {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        //Get context and set fetch predicate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Song")
        let predicate = NSPredicate(format: "title = %@", argumentArray: [songTitle])
        fetchRequest.predicate = predicate
        
        do
        {
            //Fetch the correct song using title
            let songArr = try managedContext.fetch(fetchRequest)
            //Extract song from array (need to make sure this unique)
            let song = songArr[0]
            //Get last index of song to set version number
            var index = song.value(forKey: "index") as! Int
            index += 1
            //Get set of versions associate with song
            let versionSet = song.mutableSetValue(forKey: "versions")
            
            //Get version entity
            let entity = NSEntityDescription.entity(forEntityName: "Version",
                                                    in: managedContext)!
            //Create new version to add
            let version = NSManagedObject(entity: entity, insertInto: managedContext)
            //Obtain date for new version
            let date = getDate()
            //Set URL path component, version number, and date
            version.setValue(pathComponent, forKey: "url")
            version.setValue(index, forKey: "num")
            version.setValue(date, forKey: "date")
            //Add to set of versions assocaited with song
            versionSet.add(version)
            //Update song index with new version
            song.setValue(index, forKey: "index")
            
        } catch {
            print("Failed")
        }
        
        do {
            try managedContext.save()
            print("SAVE SUCCESSFUL")
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func updateCounter()
    {
        var counter = UserDefaults.standard.integer(forKey: "Counter")
        counter += 1
        UserDefaults.standard.set(counter, forKey:"Counter")
    }
    
    func getDate() -> String
    {
        let date : Date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let todaysDate = dateFormatter.string(from: date)
        return todaysDate
    }
    
    
    
}
