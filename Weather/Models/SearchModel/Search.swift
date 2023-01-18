//
//  Search.swift
//  Weather
//
//  Created by MN on 12.01.2023.
//  Copyright © 2023 Nikita Moshyn. All rights reserved.
//
// The real-time location request requires a different model, but the model currently uses is "Location"

import Foundation

struct Search: Codable {
    
    let id: Int?
    let name: String?
    let region: String?
    let country: String?
    let lat: Double?
    let lon: Double?
    let url: String?
        

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case region = "region"
        case country = "country"
        case lat = "lat"
        case lon = "lon"
        case url = "url"
    }
}
