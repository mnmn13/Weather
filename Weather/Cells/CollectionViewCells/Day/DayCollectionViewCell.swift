//
//  DayCollectionViewCell.swift
//  Weather
//
//  Created by MN on 03.01.2023.
//  Copyright © 2023 Nikita Moshyn. All rights reserved.
//

import UIKit

class DayCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var lowTempLabel: UILabel!
    @IBOutlet weak var highTempLabel: UILabel!
    
    static let identifier = "DayCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func configure(with model: DayForecastGroup, and location: Location? ) {
        self.lowTempLabel.text = "\(Int(model.day?.mintempC ?? 0))°"
        self.highTempLabel.text = "\(Int(model.day?.maxtempC ?? 0))°"
        
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
