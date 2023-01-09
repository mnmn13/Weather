//
//  MainViewController.swift
//  Weather
//
//  Created by MN on 07.12.2022.
//  Copyright © 2022 Nikita Moshyn. All rights reserved.
//

import UIKit
import CoreLocation

class MainViewController: UIViewController {
    
    private let collectionView = UICollectionView (frame: .zero, collectionViewLayout: MainViewController.createLayout())
        
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    private var searchText: String?
    
    var locations = [Location]()
    var weatherModels = [Weather]()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(named: "background")
        setUpCollectionView()
        registerCollectionViewCells()
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupLocation()
    }
    
    //MARK: - SearchBar setup func
    //    private func setupSearchBar() {
    //        let searchController = UISearchController(searchResultsController: UIViewController?)
    //        navigationItem.searchController = searchController
    //        searchController.searchBar.delegate = self
    //        navigationController?.navigationBar.prefersLargeTitles = true
    //        searchController.obscuresBackgroundDuringPresentation = false
    //    }
    
    static func createLayout() -> UICollectionViewCompositionalLayout {
        // Item
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        
        // Group
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)), subitems: [item])
        // Sections
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .paging
        
        // Return
        return UICollectionViewCompositionalLayout(section: section)
    }
    
//MARK: - CollectionView Settings
    private func setupLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    private func setUpCollectionView() {
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.alwaysBounceVertical = false
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
                                 collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
                                 collectionView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor),
                                 collectionView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor)])
    }
    
    private func registerCollectionViewCells() {
        collectionView.register(.init(nibName: CollectionViewCell.identifier, bundle: .main), forCellWithReuseIdentifier: CollectionViewCell.identifier)
    }
}
//MARK: - CLLocationManagerDelegate
extension MainViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty, currentLocation == .none {
            currentLocation = locations.first
            NetworkManager.shared.request(lat: currentLocation?.coordinate.latitude ?? 0, lon: currentLocation?.coordinate.longitude ?? 0) { [weak self] (result: Result<Weather, Error>) in
                switch result {
                case .success(let weather):
                    self?.weatherModels = [weather, weather]
                    print(locations)
                    DispatchQueue.main.async {
                        self?.collectionView.reloadData()
                    }
                case .failure(let error):
                    print(error)
                    break
                }
            }
            locationManager.stopUpdatingLocation()
        } else {
            print(currentLocation ?? "Current location is nil")
        }
    }
}
// MARK: - SearchBar
extension MainViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
    
}
// MARK: - CollectionViewDataSource
extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weatherModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath) as? CollectionViewCell else { return .init() }
        let weather = weatherModels[indexPath.item]
        
        cell.configure(with: weather)
        return cell
    }
}

extension MainViewController: UICollectionViewDelegate {
    
}

