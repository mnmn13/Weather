//
//  TableViewCell.swift
//  Weather
//
//  Created by MN on 10.01.2023.
//  Copyright © 2023 Nikita Moshyn. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var degreeLabel: UILabel!
    @IBOutlet weak var aboutWeatherLabel: UILabel!
    @IBOutlet weak var highLowLabel: UILabel!
    @IBOutlet weak var uiView: UIView!
    
    static let identifier = "TableViewCell"
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func registerCell() {
        
    }
    
    func configure(with weatherModel: Weather) {
        locationLabel.text = weatherModel.location?.name
        degreeLabel.text = String(format: "%.0f", weatherModel.current?.tempC ?? 0)
        highLowLabel.text = "H:\(String(format: "%.0f", weatherModel.forecast?.forecastday?.first?.day?.maxtempC ?? 0.0))° L:\(String(format: "%.0f", weatherModel.forecast?.forecastday?.first?.day?.mintempC ?? 0.0))°"
        aboutWeatherLabel.text = weatherModel.current?.condition?.text
        
        locationLabel.textColor = .white
        degreeLabel.textColor = .white
        aboutWeatherLabel.textColor = .white
        highLowLabel.textColor = .white
        uiView.backgroundColor = .darkGray
        uiView.layer.cornerRadius = 15
        
    }
    
}
