//
//  AboutWeatherCollectionViewCell.swift
//  Weather
//
//  Created by MN on 03.01.2023.
//  Copyright © 2023 Nikita Moshyn. All rights reserved.
//

import UIKit

class AboutWeatherCollectionViewCell: UICollectionViewCell {
        
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var additionalContentLabel: UILabel!
    
    static let identifier = "AboutWeatherCollectionViewCell"
    
    let icons = ["UV" : UIImage(systemName: "sun.max.fill"),
                "Sunset" : UIImage(systemName: "sunset.fill"),
                "Wind" : UIImage(systemName: "wind"),
                "Rainfall" : UIImage(systemName: "drop.fill"),
                "FeelsLike" : UIImage(systemName: "thermometer"),
                "Humidity" : UIImage(systemName: "humidity"),
                "Visibility" : UIImage(systemName: "eye.fill"),
                "Pressure" : UIImage(systemName: "gauge")]
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with model: Current,and astroModel: AstroForecast, and numberItems: Int, and hour: HourForecast) {
        
        
        
        titleLabel.text = {
            switch numberItems {
            case 0:
                return "UV INDEX"
            case 1:
                return "SUNRISE"
            case 2:
                return "WIND"
            case 3:
                return "PRENCIPITATION"
            case 4:
                return "FEELS LIKE"
            case 5:
                return "HUMIDITY"
            case 6:
                return "VISIBILITY"
            case 7:
                return "PRESSURE"
            default:
                return ""
            }
        }()
        
        contentLabel.text = {
            switch numberItems {
            case 0:
                return String(model.uv ?? 0)
            case 1:
                return String(astroModel.sunset ?? "")
            case 2:
                return String(format: "%g", model.windKph ?? 0) + " km/h"
            case 3:
                return String(format: "%g", model.pressureMB ?? 0) + "mm"
            case 4:
                return String(format: "%g", model.feelslikeC ?? 0) + "°"
            case 5:
                return String(model.humidity ?? 0) + "%"
            case 6:
                return String(format: "%g", model.visKM ?? 0) + "km"
            case 7:
                return String(format: "%g", model.pressureIn ?? 0)
            default:
                return ""
            }
        }()
    
        iconImageView.image = {
            switch numberItems {
            case 0:
                return UIImage(systemName: "sun.max.fill")! // UV
            case 1:
                return UIImage(systemName: "sunset.fill")! // Sunset
            case 2:
                return UIImage(systemName: "wind")! // Wind
            case 3:
                return UIImage(systemName: "drop.fill")! // Rainfall
            case 4:
                return UIImage(systemName: "thermometer")! // FeelsLike
            case 5:
                return UIImage(systemName: "humidity")! // Humidity
            case 6:
                return UIImage(systemName: "eye.fill")! // Visibility
            case 7:
                return UIImage(systemName: "gauge")! // Pressure
            default:
                return UIImage(systemName: "questionmark.circle")! // ?
            }
        }()
        additionalContentLabel.text = {
            switch numberItems {
            case 0:
                guard let uv = model.uv else { return "No data available" }
                if uv <= 2 {
                    return "Low"
                } else if uv >= 3 {
                    return "Moderate"
                } else if uv >= 6 {
                    return "High"
                } else if uv >= 8 {
                   return "Very high"
                } else if uv >= 11 {
                    return "Extreme"
                } else {
                    return "No data available"
                }

            case 1:
                return "Sunset: \(astroModel.sunset ?? "")"
            case 2:
                return ""
            case 3:
                return ""
            case 4:
                return ""
            case 5:
                return "The dew point is \(String(format: "%.0f", hour.dewpointC ?? 0.0))° right now."
            case 6:
                return ""
            case 7:
                return ""
            default:
                return ""
            }
        }()
    }
}
