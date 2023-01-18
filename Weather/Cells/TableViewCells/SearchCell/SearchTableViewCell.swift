//
//  SearchTableViewCell.swift
//  Weather
//
//  Created by MN on 11.01.2023.
//  Copyright © 2023 Nikita Moshyn. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var locationLabel: UILabel!
    
    static let identifier = "SearchTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(with location: Location) {
        self.locationLabel.text = "\(location.name ?? ""), \(location.region ?? ""), \(location.country ?? "")"
    }
}
