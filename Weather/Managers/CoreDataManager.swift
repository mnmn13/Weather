//
//  CoreDataManager.swift
//  Weather
//
//  Created by MN on 16.12.2022.
//  Copyright © 2022 Nikita Moshyn. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
    
    private static var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "Weather")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    private static var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    // MARK: - Core Data Saving support

    static func saveContext () {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
/*
extension CoreDataManager {
    static func getNotes() -> [Note] {
            let request = Note.fetchRequest()
        do {
            let notes = try context.fetch(request)
            return notes
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    static func create(title: String?, content: String?) -> Note {
        let note = Note(context: context)
        note.title = title ?? ""
        note.content = content ?? ""
        saveContext()
        return note
    }
    
    static func delete(note: Note) {
        context.delete(note)
        saveContext()
    }
    
    static func deleteAll() {
        let notes = getNotes()
        notes.forEach { note in
            delete(note: note)
        }
    }
    
    static func resave(notes: [Note]) {
        notes.forEach { note in
            let newNote = create(title: note.title, content: note.content)
            delete(note: note)
        }
    }
}
*/
