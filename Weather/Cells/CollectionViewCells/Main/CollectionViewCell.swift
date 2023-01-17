//
//  CollectionViewCell.swift
//  Weather
//
//  Created by MN on 27.12.2022.
//  Copyright © 2022 Nikita Moshyn. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var degreeLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var maxMinTempLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    static let identifier = "CollectionViewCell"
    private var model: Weather?
    private var hour: HourForecast?
    
    private lazy var hours: [HourForecast] = {
        guard let currentDayHours = model?.forecast?.forecastday?.first?.hour,
             let nextDayHours = model?.forecast?.forecastday?[1].hour else { return [] }
        
        let currentHour = Calendar.current.component(.hour, from: Date())
        
        let hoursAfterCurrentHour = currentDayHours.filter { hourForecast in
            guard let date = hourForecast.getDate() else { return false }
            let hour = Calendar.current.component(.hour, from: date)
            return hour >= currentHour
        }
        
        let hoursBeforeNextDayCurrentHour = nextDayHours.filter { hourforecast in
            guard let date = hourforecast.getDate() else { return false }
            let hour = Calendar.current.component(.hour, from: date)
            return hour < currentHour
        }
        
        return hoursAfterCurrentHour + hoursBeforeNextDayCurrentHour
    }()
    
    private var days: [DayForecastGroup] {
        return model?.forecast?.forecastday ?? []
    }
    
    
    //    private var sections = [Sections]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureCollectionView()
    }
    
    func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset.bottom = 50
        collectionView.collectionViewLayout = createLayout()
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        //        collectionView = UICollectionView( frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: createLayout())
        registerCells()
    }
    
    func registerCells() {
        collectionView.register(.init(nibName: HourCollectionViewCell.identifier, bundle: .main), forCellWithReuseIdentifier: HourCollectionViewCell.identifier)
        collectionView.register(.init(nibName: DayCollectionViewCell.identifier, bundle: .main), forCellWithReuseIdentifier: DayCollectionViewCell.identifier)
        collectionView.register(.init(nibName: AboutWeatherCollectionViewCell.identifier, bundle: .main), forCellWithReuseIdentifier: AboutWeatherCollectionViewCell.identifier)
    }
    
    func configure (with model: Weather) {
        self.model = model
        self.cityNameLabel.text = "\(model.location?.name ?? "")"
        self.degreeLabel.text = String(format: "%.0f", model.current?.tempC ?? 0) + "°"
        self.weatherDescriptionLabel.text = "\(model.current?.condition?.text ?? "")"

        self.maxMinTempLabel.text = "H: \(String(format: "%.0f", model.forecast?.forecastday?[0].day?.maxtempC ?? 0))° L: \(String(format: "%.0f", model.forecast?.forecastday?[0].day?.mintempC ?? 0))°"
    }
    
    //MARK: - UICollectionViewCompositionalLayout
    private func createLayout() -> UICollectionViewCompositionalLayout {
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 10
        
        let layout = UICollectionViewCompositionalLayout(sectionProvider: { [weak self] (section, layoutEnvirnment) -> NSCollectionLayoutSection? in
            guard let self = self else { return nil }
            switch section {
            case 0: return self.createHourLayout()
            case 1: return self.createDayListSection()
            case 2: return self.createAboutWeatherGridSection()
            default: return nil
            }}, configuration: config)
        layout.register(CellBackgroundViews.self, forDecorationViewOfKind: CellBackgroundViews.identifier)
        return layout
        
        
        
//        return .init { [weak self] section, enviroment in
//            guard let self = self else { return nil }
//            switch section {
//            case 0: return self.createHourLayout()
//            case 1: return self.createDayListSection()
//            case 2: return self.createAboutWeatherGridSection()
//            default: return nil
//            }
//        }
    }
    
    //MARK: - NSCollectionLayoutSection
    private func createHourLayout() -> NSCollectionLayoutSection {
        // Item
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(88)))
        // Group
        let itemGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.2), heightDimension: item.layoutSize.heightDimension), repeatingSubitem: item, count: 1)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: item.layoutSize.heightDimension), subitems: [itemGroup])
        // Sections
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        section.decorationItems = [NSCollectionLayoutDecorationItem.background(elementKind: CellBackgroundViews.identifier)]
        
        // Return
        return section
    }
    
    private func createDayListSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(85)))
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: item.layoutSize.widthDimension, heightDimension: item.layoutSize.heightDimension), subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.decorationItems = [NSCollectionLayoutDecorationItem.background(elementKind: CellBackgroundViews.identifier)]
        return section
    }
    
    private func createAboutWeatherGridSection() -> NSCollectionLayoutSection {

        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .absolute(180)))
        let hGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: item.layoutSize.heightDimension), repeatingSubitem: item, count: 2)
        hGroup.interItemSpacing = .fixed(10)

        let vGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(720)), subitems: [hGroup])

        let section = NSCollectionLayoutSection(group: vGroup)
        section.interGroupSpacing = 10
//        section.interGroupSpacing = 10
//        section.decorationItems = [NSCollectionLayoutDecorationItem.background(elementKind: CellBackgroundViews.identifier)]
        return section
    }
    
//    private func createAboutWeatherGridSection() -> NSCollectionLayoutSection {
//        // section -> groups -> items -> size
//        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
//                                              heightDimension: .fractionalHeight(1.0))
//        let item = NSCollectionLayoutItem(layoutSize: itemSize)
//        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
//                                               heightDimension: .fractionalWidth(0.5))
//        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 2)
//        let spacing = CGFloat(20)
//        group.interItemSpacing = .fixed(spacing)
//        let section = NSCollectionLayoutSection(group: group)
//        section.interGroupSpacing = spacing
//        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: spacing, bottom: 0, trailing: spacing)
//        section.decorationItems = [NSCollectionLayoutDecorationItem.background(elementKind: CellBackgroundViews.identifier)]
//        let layout = UICollectionViewCompositionalLayout(section: section)
//        return section
//    }
}

// MARK: - CollectionViewDataSource
extension CollectionViewCell: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0: return hours.count
        case 1: return days.count
        case 2: return 8
        default: return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.section {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HourCollectionViewCell.identifier, for: indexPath) as? HourCollectionViewCell,
                  hours.indices.contains(indexPath.item) else { return .init() }
            let hour = hours[indexPath.item]
            cell.configure(with: hour)
            return cell
        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DayCollectionViewCell.identifier, for: indexPath) as? DayCollectionViewCell else { return .init() }
            let day = days[indexPath.item]
            let location = model?.location
            cell.configure(with: day, and: location)
            return cell
        case 2:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AboutWeatherCollectionViewCell.identifier, for: indexPath) as? AboutWeatherCollectionViewCell else { return .init() }
            
            guard let astro = model?.forecast?.forecastday?.first?.astro,
                  let current = model?.current else { return .init() }
            let hour = hours[indexPath.item]
            cell.configure(with: current, and: astro, and: indexPath.item, and: hour)
            cell.backgroundColor = #colorLiteral(red: 0.4629999995, green: 0.4629999995, blue: 0.5019999743, alpha: 0.4)
            cell.layer.cornerRadius = 15
            cell.layer.masksToBounds = true
            return cell
        default: return .init()
        }
    }
}

extension CollectionViewCell: UICollectionViewDelegate {
    
}

//enum Sections {
//    case hour(items: [HourForecast])
//    case day
//    case about
//}
