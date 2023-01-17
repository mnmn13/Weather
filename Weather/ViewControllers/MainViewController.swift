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
    //    private let collectionView = UICollectionView (frame: .zero, collectionViewLayout: MainViewController.createLayout())
    //    private var toolBar: UIToolbar!
    private var pageControl: UIPageControl!
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    private var searchText: String?
    
    var locations = [Location]()
    var weatherModels = [Weather]()
    var locationsCoreData: [Search] = []
    var secondSearchLocation = [Location]()
    weak var menuVC: MenuViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .darkGray  //UIColor(named: "background")
        setUpCollectionView()
        registerCollectionViewCells()
        setupToolBar()
        setupPageControl()
//        setupLocation()
//        fetchLocations()
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupLocation()
//        fetchLocations()
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    private func fetchLocations() {
        locations = CoreDataManager.getAllLocations()
        if locations.isEmpty {
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
    
    func updateCV() {
            
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)), subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .paging
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    //MARK: - CollectionView Settings
    private func setupLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    private func setUpCollectionView() {
        collectionView.collectionViewLayout = createLayout()
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.alwaysBounceVertical = false
        //        view.addSubview(collectionView)
        //        NSLayoutConstraint.activate([collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
        //                                 collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        //                                 collectionView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor),
        //                                 collectionView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor)])
    }
    
    private func registerCollectionViewCells() {
        collectionView.register(.init(nibName: CollectionViewCell.identifier, bundle: .main), forCellWithReuseIdentifier: CollectionViewCell.identifier)
    }
    // MARK: - PageContol
    private func setupPageControl() {
        pageControl = UIPageControl(frame: CGRect(origin: .zero, size: CGSize(width: view.frame.width / 2, height: 1)))
        //        view.addSubview(pageControl)
        pageControl.addTarget(self, action: #selector(PCTapped), for: .valueChanged)
        pageControl.hidesForSinglePage = true
        
    }
    @objc func PCTapped(_ sender: UIPageControl) {
        collectionView.scrollToItem(at: IndexPath(row: sender.currentPage, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    //MARK: - ToolBar
    private func setupToolBar() {
        //        toolBar.backgroundColor = #colorLiteral(red: 0.4629999995, green: 0.4629999995, blue: 0.5019999743, alpha: 0.4)
        
        let items: [UIBarButtonItem] = [
            UIBarButtonItem(image: UIImage(systemName: "map"), style: .plain, target: self, action: #selector(mapButtonTapped)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            //            UIBarButtonItem(customView: pageControl),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "list.bullet"), style: .plain, target: self, action: #selector(listButtonTapped))
        ]
        toolBar.items = items
        
        let appearence = UIToolbarAppearance()
        appearence.configureWithTransparentBackground()
        appearence.backgroundColor  = .secondarySystemFill.withAlphaComponent(0.4)
        toolBar.standardAppearance = appearence
        
    }
    @objc func mapButtonTapped(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Ooops..", message: "Maybe it will be available in the next version.", preferredStyle: .alert)
        let action = UIAlertAction(title: "I hope so", style: .default)
        alertController.addAction(action)
        
        self.present(alertController, animated: true)
    }
    @objc func listButtonTapped() {
        let storyboard = UIStoryboard(name: "Menu", bundle: nil)
        //        let vc = storyboard.instantiateViewController(withIdentifier: "menu")
        let vc = storyboard.instantiateViewController(withIdentifier: "menu") as! MenuViewController
        vc.mainVC = self
        
        vc.configure(with: weatherModels)
        navigationController?.pushViewController(vc, animated: true)
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
                    self?.weatherModels.append(weather)
                    print(locations)
                    DispatchQueue.main.async {
                        self?.collectionView.reloadData()
                        self?.pageControl.numberOfPages = self?.weatherModels.count ?? 0
                        self?.fetchLocations()
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

extension MainViewController: UICollectionViewDelegate {
    
}

//extension MainViewController: UICollectionViewDelegateFlowLayout {
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//
//        let index = Int(round(scrollView.contentOffset.x / (scrollView.frame.width)))
//        pageControl.currentPage = index
//        let weatherModel = weatherModels[index]
//        UIView.animate(withDuration: 0.5) {
//
//        }
//    }
//}

