//
//  Forecast.swift
//  Weather
//
//  Created by MN on 13.12.2022.
//  Copyright © 2022 Nikita Moshyn. All rights reserved.
//

import Foundation

struct Forecast: Codable {
    let forecastday: [DayForecastGroup]?

//    enum CodingKeys: String, CodingKey {
//        case forecastday = "forecastday"
//    }
}
