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
    
    func saveVersionToModel(pathComponent: String)
    {
        
    }
    
    func updateCounter()
    {
        var counter = UserDefaults.standard.integer(forKey: "Counter")
        counter += 1
        UserDefaults.standard.set(counter, forKey:"Counter")
    }
    
    
    
}
