//
//  Location.swift
//  Weather
//
//  Created by MN on 08.12.2022.
//  Copyright © 2022 Nikita Moshyn. All rights reserved.
//

import Foundation

struct Location: Codable {
    let name: String?
    let region: String?
    let country: String?
    let lat: Double?
    let lon: Double?
    let tzID: String?
    let localtimeEpoch: Int?
    let localtime: String?

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
    
    func getDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd H:mm"
        guard let dateString = localtime else { return nil }
        let date = dateFormatter.date(from: dateString)
        return date
    }
}
