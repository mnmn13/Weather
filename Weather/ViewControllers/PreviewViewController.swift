//
//  PreviewViewController.swift
//  Weather
//
//  Created by MN on 12.01.2023.
//  Copyright © 2023 Nikita Moshyn. All rights reserved.
//

import UIKit

class PreviewViewController: UIViewController {
    
    
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var collectionView: UICollectionView!
    //    private var collectionView: UICollectionView!
    //    @IBOutlet weak var navigationItem: UINavigationBar!
    
    weak var menuVC: MenuViewController!
    weak var mainVC: MainViewController?
    
    private var locationSearchModel = [Location]()
    private var weatherModel = [Weather]()
    private var locationToRequest = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        request()
        setUpCollectionView()
        setupNav()
        self.view.backgroundColor = .darkGray
    }
    
    func configure(with locationToRequest: String, locationSearchModel: [Location]) {
        self.locationToRequest = locationToRequest
        self.locationSearchModel = locationSearchModel
    }
    
    private func setupNav() {
        
        self.navigationBar.tintColor = .clear
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        let cancellButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped))
        addButton.tintColor = .blue
        cancellButton.tintColor = .blue
        
        self.navItem.leftBarButtonItem = cancellButton
        self.navItem.rightBarButtonItem = addButton
    }
    
    @objc private func cancelTapped() {
        self.dismiss(animated: true)
    }
    
    @objc private func addTapped() {
        
        guard let location = locationSearchModel.first else { return }
        
        CoreDataManager.saveLocation(location)
        guard let weather = weatherModel.first else { return }
        menuVC.weatherModels.append(weather)
        menuVC?.reloadTV()
        menuVC?.dismiss(animated: true)
        menuVC.searchText.removeAll()
        menuVC.searchController.searchBar.searchTextField.text?.removeAll()
        menuVC?.searchController.searchBar.searchTextField.resignFirstResponder()
        
        self.dismiss(animated: true)
    }
    
    private func request() {
        
        NetworkManager.shared.request(search: locationToRequest) { (result: Result<Weather, Error>) in
            
            switch result {
            case .success(let weather):
                self.weatherModel.append(weather)
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func registerCell() {
        collectionView.register(.init(nibName: CollectionViewCell.identifier, bundle: .main), forCellWithReuseIdentifier: CollectionViewCell.identifier)
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
        //                                     collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        //                                     collectionView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor),
        //                                     collectionView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor)])
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)), subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        //        section.orthogonalScrollingBehavior = .paging
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}

extension PreviewViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weatherModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath) as? CollectionViewCell else { return .init() }
        let weather = weatherModel[indexPath.item]
        
        cell.configure(with: weather)
        return cell
    }
}

extension PreviewViewController: UICollectionViewDelegate {
    
}
