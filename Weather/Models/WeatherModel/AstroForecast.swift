//
//  AstroForecast.swift
//  Weather
//
//  Created by MN on 13.12.2022.
//  Copyright © 2022 Nikita Moshyn. All rights reserved.
//

import Foundation

struct AstroForecast: Codable {
    let sunrise: String?
    let sunset: String?
    let moonrise: String?
    let moonset: String?
    let moonPhase: String?
    let moonIllumination: String?
    
    enum CodingKeys: String, CodingKey {
        case sunrise = "sunrise"
        case sunset = "sunset"
        case moonrise = "moonrise"
        case moonset = "moonset"
        case moonPhase = "moon_phase"
        case moonIllumination = "moon_illumination"
    }
}
