//
//  MenuViewController.swift
//  Weather
//
//  Created by MN on 09.01.2023.
//  Copyright © 2023 Nikita Moshyn. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    
    private var tableView: UITableView!
    let searchController = UISearchController(searchResultsController: nil)
    private var searchBar: UISearchBar!
    
    weak var mainVC: MainViewController!
    //    private var searchController: UISearchController!
    
    var weatherModels = [Weather]()
    private var weatherModel = [Weather]()
    private var locationSearchModel = [Location]()
    
    var searchText: String = ""
    
    var searchResultsModel: Weather?
    
    //    private var searchResultsLocationModel: [Location?]
    
    
    
    static let identifier = "MenuViewController"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTV()
        registerCell()
        setupSearchController()
        title = "Weather"
        self.navigationItem.leftBarButtonItem?.isHidden = true
        //        self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.navigationItem.hidesBackButton = true
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    @objc func action() {
        
        let storyboard = UIStoryboard(name: "Preview", bundle: .none)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "preview") as? PreviewViewController else { return }
        let model = "123"
        vc.menuVC = self
        vc.configure(with: model, locationSearchModel: locationSearchModel)
        
        self.present(vc, animated: true, completion: nil)
        
    }
    
    private func setupTV() {
        
        tableView = UITableView(frame: view.bounds)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .black
        tableView.separatorStyle = .none
        view.addSubview(tableView)
        //        NSLayoutConstraint.activate([
        //            tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
        //            tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
        //            tableView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor),
        //            tableView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor)])
    }
    func reloadTV() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    private func registerCell() {
        tableView.register(UINib(nibName: TableViewCell.identifier, bundle: .main), forCellReuseIdentifier: TableViewCell.identifier)
        tableView.register(UINib(nibName: SearchTableViewCell.identifier, bundle: .main), forCellReuseIdentifier: SearchTableViewCell.identifier)
        
    }
    
    func configure(with weatherModels: [Weather]) {
        self.weatherModels = weatherModels
    }
    //    MARK: - SearchController setup func
    private func setupSearchController() {
        
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.backgroundColor = .black
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        
        navigationController?.navigationBar.prefersLargeTitles = true
        //        searchController.obscuresBackgroundDuringPresentation = false
    }
    
    
}
//MARK: - UITableViewDelegate
extension MenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        //        notes.swapAt(fromIndexPath.row, to.row)
        //        CoreDataManager.
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { [weak self] _, _, completionHandler in
            if let location = self?.weatherModels[indexPath.row].location {
                CoreDataManager.deleteLocation(location)
            }
            self?.weatherModels.remove(at: indexPath.row)
            self?.mainVC.weatherModels.remove(at: indexPath.item)
            self?.tableView.deleteRows(at: [indexPath], with: .fade)
            completionHandler(true)
            
        }
        deleteAction.image = UIImage(systemName: "trash")?.withTintColor(.systemRed, renderingMode: .alwaysOriginal)
        deleteAction.backgroundColor = .black
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
    //    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //
    //        mainVC.locations = self.weatherModels.compactMap { $0.location }
    //        mainVC.weatherModels = self.weatherModels
    ////        mainVC.pagecontrol.currentPage = indexPath.row
    //
    //        let weatherModel = mainVC.weatherModels[indexPath.row]
    
    
    //        navigationController?.customPop()
    //    }
    
}
//MARK: - UITableViewDataSource
extension MenuViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if !searchText.isEmpty {
            return locationSearchModel.count
        } else {
            return weatherModels.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if !searchText.isEmpty {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier, for: indexPath) as? SearchTableViewCell else { return .init() }
            //            guard let searchResultsModel = locationSearchModels else { return .init() }
            let model = locationSearchModel[indexPath.item]
            cell.configure(with: model)
            cell.backgroundColor = .clear
            cell.clipsToBounds = true
            return cell
            
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath) as? TableViewCell else { return .init() }
            let model = weatherModels[indexPath.item]
            cell.configure(with: model)
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if !searchText.isEmpty {
            let storyboard = UIStoryboard(name: "Preview", bundle: .main)
            guard let vc = storyboard.instantiateViewController(withIdentifier: "preview") as? PreviewViewController else { return }
            guard let model = locationSearchModel[indexPath.item].name else { return }
            vc.menuVC = self
            vc.configure(with: model, locationSearchModel: locationSearchModel)
            
            self.present(vc, animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
            mainVC.weatherModels = self.weatherModels
            DispatchQueue.main.async {
                self.mainVC.collectionView.reloadData()
            }
            mainVC.collectionView.scrollToItem(at: IndexPath(row: indexPath.row, section: 0), at: .centeredHorizontally, animated: false)
        }
    }
}

// MARK: - SearchBar
extension MenuViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            self.searchText.removeAll()
            self.tableView.reloadData()
            return
        }
        
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        perform(#selector(searchLocation(text:)), with: searchText, afterDelay: 0.5)
        
    }
    
    @objc private func searchLocation(text: String) {
        NetworkManager.shared.request(searchLocation: text) { [weak self] (result: Result<[Location], Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let location):
                self.locationSearchModel = location
                self.searchText = text
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
                print(location)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchText.removeAll()
        self.tableView.reloadData()
    }
}

