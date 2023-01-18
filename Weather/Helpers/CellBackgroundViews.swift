//
//  CellBackgroundViews.swift
//  Weather
//
//  Created by MN on 08.01.2023.
//  Copyright © 2023 Nikita Moshyn. All rights reserved.
//

import Foundation
import UIKit

class CellBackgroundViews: UICollectionReusableView {
    static let identifier = "CellBackgroundViews"
    
    private var insetView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = #colorLiteral(red: 0.4629999995, green: 0.4629999995, blue: 0.5019999743, alpha: 0.4)
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        addSubview(insetView)
        
        NSLayoutConstraint.activate([
            insetView.leadingAnchor.constraint(equalTo: leadingAnchor),
            insetView.trailingAnchor.constraint(equalTo: trailingAnchor),
            insetView.topAnchor.constraint(equalTo: topAnchor),
            insetView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
