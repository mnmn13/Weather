//
//  HourCollectionViewCell.swift
//  Weather
//
//  Created by MN on 03.01.2023.
//  Copyright © 2023 Nikita Moshyn. All rights reserved.
//

import UIKit

class HourCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var hourDegreeLabel: UILabel!
    
    var model: HourForecast!
    
    static let identifier = "HourCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with model: HourForecast) {
        self.model = model
        
        if let date = model.getDate() {
            let hoursString = date.time.hour < 10 ? "0\(date.time.hour)" : "\(date.time.hour)"
            
            var minutesString = ""
            
            if  date.time.minute > 0 {
                minutesString = date.time.minute < 10 ? ":0\(date.time.minute)" : ":\(date.time.minute)"
            }
            hourLabel.text = hoursString + minutesString
        } else {
            hourLabel.text = model.time
        }
        if let temp = model.tempC {
            hourDegreeLabel.text = String(Int(temp)) + "°"
        } else {
            hourDegreeLabel.text = model.condition?.text
        }
        model.condition?.getImage(handler: { [weak self] image in
            DispatchQueue.main.async {
                self?.imageView.image = image
            }
        })
    }    
}
