//
//  Weather.swift
//  Weather
//
//  Created by MN on 09.12.2022.
//  Copyright © 2022 Nikita Moshyn. All rights reserved.
//

import Foundation

// MARK: - Weather
struct Weather: Codable {
    let location: Location?
    let current: Current?
    let forecast: Forecast?
}
