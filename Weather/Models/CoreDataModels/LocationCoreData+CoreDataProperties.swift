//
//  LocationCoreData+CoreDataProperties.swift
//  
//
//  Created by MN on 09.01.2023.
//
//

import Foundation
import CoreData


extension LocationCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LocationCoreData> {
        return NSFetchRequest<LocationCoreData>(entityName: "LocationCoreData")
    }

    @NSManaged public var city: String?
    @NSManaged public var country: String?
    @NSManaged public var lat: Double
    @NSManaged public var long: Double
    @NSManaged public var region: String?
}

extension LocationCoreData : Identifiable {

}
