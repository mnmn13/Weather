//
//  Location.swift
//  Weather
//
//  Created by MN on 08.12.2022.
//  Copyright © 2022 Nikita Moshyn. All rights reserved.
//

import Foundation
import CoreData

struct Location: Codable {
    let name: String?
    let region: String?
    let country: String?
    let lat: Double?
    let lon: Double?
    let tzID: String?
    let localtimeEpoch: Int?
    let localtime: String?
    
    
    init(_ location: LocationCoreData) {
        self.lat = location.lat
        self.lon = location.long
        self.name = location.city
        self.region = location.region
        self.country = location.country
        self.tzID = nil
        self.localtime = nil
        self.localtimeEpoch = nil
    }

    enum CodingKeys: String, CodingKey {
        case name = "name"
        case region = "region"
        case country = "country"
        case lat = "lat"
        case lon = "lon"
        case tzID = "tz_id"
        case localtimeEpoch = "localtime_epoch"
        case localtime = "localtime"
    }
    
    static func fetchFromCoreDataLocations(_ locations: [LocationCoreData]) -> [Location] {
        return locations.map { Location($0) }
    }
    

    func toCoreData(with context: NSManagedObjectContext) -> LocationCoreData {
        let locationCoreData = LocationCoreData(context: context)
        locationCoreData.long = self.lon ?? 0
        locationCoreData.lat = self.lat ?? 0
        locationCoreData.country = self.country
        locationCoreData.city = self.name
        locationCoreData.region = self.region
        return locationCoreData
    }
    
    func getDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd H:mm"
        guard let dateString = localtime else { return nil }
        let date = dateFormatter.date(from: dateString)
        return date
    }
}
