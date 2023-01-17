//
//  DayForecastGroup.swift
//  Weather
//
//  Created by MN on 13.12.2022.
//  Copyright © 2022 Nikita Moshyn. All rights reserved.
//

import Foundation

struct DayForecastGroup: Codable {
    let date: String?
    let dateEpoch: Int?
    let day: DayForecast?
    let astro: AstroForecast?
    let hour: [HourForecast]?

    enum CodingKeys: String, CodingKey {
        case date = "date"
        case dateEpoch = "date_epoch"
        case day = "day"
        case astro = "astro"
        case hour = "hour"
    }
    func getDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
//        dateFormatter.dateFormat = "dd-MM-yyyy"
        guard let dateString = date else { return nil }
        let date = dateFormatter.date(from: dateString)
        return date
    }
}

extension Date {
    var time: Time {
        return Time(self)
    }
    
    var weekDay: Int {
        return Calendar.current.component(.weekday, from: self)
    }
    
    var hour: Int {
        return Calendar.current.component(.hour, from: self)
    }
    
}
