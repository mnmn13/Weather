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
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var toolBar: UIToolbar!
    private var pageControl: UIPageControl!
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    private var searchText: String?
    
    var locations = [Location]()
    var weatherModels = [Weather]()
    
    weak var menuVC: MenuViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .darkGray
        setUpCollectionView()
        registerCollectionViewCells()
        setupToolBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupLocation()
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    //MARK: - Request for location from CoreData
    private func fetchLocations() {
        locations = CoreDataManager.getLocations()
        if locations.isEmpty, weatherModels.isEmpty {
            listButtonTapped()
            print("CoreData locations is empty")
        } else {
            for location in locations {
                
                NetworkManager.shared.request(search: location.name ?? "") { [weak self] (result: Result<Weather, Error>) in
                    guard let self = self else { return }
                    
                    switch result {
                    case .success(let weather):
                        self.weatherModels.append(weather)
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                        }
                    case .failure(let error):
                        print(error)
                    }
                }
            }
        }
    }
    //MARK: - Creating UICollectionViewCompositionalLayout
    private func createLayout() -> UICollectionViewCompositionalLayout {
        
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)), subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .paging
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    //MARK: - Location Settings
    private func setupLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    //MARK: - CollectionView Settings
    private func setUpCollectionView() {
        collectionView.collectionViewLayout = createLayout()
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.alwaysBounceVertical = false
    }
    // Register collectionView cells
    private func registerCollectionViewCells() {
        collectionView.register(.init(nibName: CollectionViewCell.identifier, bundle: .main), forCellWithReuseIdentifier: CollectionViewCell.identifier)
    }
    //MARK: - ToolBar
    private func setupToolBar() {
        
        let items: [UIBarButtonItem] = [
            UIBarButtonItem(image: UIImage(systemName: "map"), style: .plain, target: self, action: #selector(mapButtonTapped)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            //            Page control - coming soon
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "list.bullet"), style: .plain, target: self, action: #selector(listButtonTapped))]
        toolBar.items = items
        
        let appearence = UIToolbarAppearance()
        appearence.configureWithTransparentBackground()
        appearence.backgroundColor  = .secondarySystemFill.withAlphaComponent(0.4)
        toolBar.standardAppearance = appearence
        
    }
    //MARK: - Action buttons
    @objc func mapButtonTapped(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Ooops..", message: "Maybe it will be available in the next version.", preferredStyle: .alert)
        let action = UIAlertAction(title: "I hope so", style: .default)
        alertController.addAction(action)
        
        self.present(alertController, animated: true)
    }
    @objc func listButtonTapped() {
        let storyboard = UIStoryboard(name: "Menu", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "menu") as! MenuViewController
        vc.mainVC = self
        vc.configure(with: weatherModels)
        navigationController?.pushViewController(vc, animated: true)
    }
}
//MARK: - CLLocationManagerDelegate + Request
extension MainViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty, currentLocation == .none {
            currentLocation = locations.first
            NetworkManager.shared.request(lat: currentLocation?.coordinate.latitude ?? 0, lon: currentLocation?.coordinate.longitude ?? 0) { [weak self] (result: Result<Weather, Error>) in
                switch result {
                case .success(let weather):
                    self?.weatherModels.append(weather)
                    print(locations)
                    DispatchQueue.main.async {
                        self?.collectionView.reloadData()
                        self?.fetchLocations() // func to load lodations from CoreData
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
// MARK: - UICollectionViewDelegate
extension MainViewController: UICollectionViewDelegate {
    
}
