//
//  WeatherTableViewCell.swift
//  Weather
//
//  Created by MN on 07.12.2022.
//  Copyright © 2022 Nikita Moshyn. All rights reserved.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {
    
    @IBOutlet var dayLabel: UILabel!
    @IBOutlet var hiTempLabel: UILabel!
    @IBOutlet var lowTempLabel: UILabel!
    @IBOutlet var iconImageView: UIImageView!
    
    private var model = DayForecastGroup.self
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .gray
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    static let identifier = "WeatherTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "WeatherTableViewCell", bundle: .main)
    }
    
    func setupDate() {
        //        var model = self.model
        
    }
    
    func configure(with model: DayForecastGroup, and location: Location? ) {
        self.lowTempLabel.text = "\(Int(model.day?.mintempC ?? 0))°"
        self.hiTempLabel.text = "\(Int(model.day?.maxtempC ?? 0))°"
        
        if let date = model.getDate() {
            let weekdayNumber = date.weekDay
            let weekday: String
            switch weekdayNumber {
            case 1: weekday = "Sun"
            case 2: weekday = "Mon"
            case 3: weekday = "Tue"
            case 4: weekday = "Wed"
            case 5: weekday = "Thu"
            case 6: weekday = "Fri"
            case 7: weekday = "Sat"
            default: weekday = ""
            }
            dayLabel.text = location?.getDate()?.weekDay == date.weekDay ? "Today" : "\(weekday)"
            
            model.day?.condition?.getImage(handler: { [weak self] image in
                guard let image = image else { return }
                //                 self?.imageView!.image = image
                DispatchQueue.main.async {
                    self?.iconImageView.image = image
                }
            })
        }
    }
}
