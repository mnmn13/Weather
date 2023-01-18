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
        
        let container = NSPersistentContainer(name: "Weather")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
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
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

extension CoreDataManager {
    // Get locations from CoreData
    static func getLocations() -> [Location] {
        
        let request = LocationCoreData.fetchRequest()
        do {
            let locations = try context.fetch(request)
            return Location.fetchFromCoreDataLocations(locations)
        } catch {
            print(error.localizedDescription)
            return [Location]()
        }
    }
    // Delete location
    static func deleteLocation(_ location: Location) {
        let request = LocationCoreData.fetchRequest()
        do {
            let locations = try context.fetch(request)
            let neededLocation = locations.first { loc in
                return loc.lat == location.lat &&
                loc.long == location.lon &&
                loc.city == location.name &&
                loc.region == location.region &&
                loc.country == location.country
            }
            if let neededLocation = neededLocation {
                context.delete(neededLocation)
                
                CoreDataManager.saveContext()
            }
            
        } catch {
            print(error.localizedDescription)
        }
    }
    // Helpers
    static func delete(location: LocationCoreData) {
        context.delete(location)
        saveContext()
    }
    
    static func reSave(locations: [LocationCoreData]) {
        locations.forEach { location in
            delete(location: location)
            CoreDataManager.saveContext()
        }
    }
    
    static func saveLocation(_ location: Location) {
        let _ = location.toCoreData(with: context)
        CoreDataManager.saveContext()
    }
}

