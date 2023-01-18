//
//  NetworkManager.swift
//  Weather
//
//  Created by MN on 08.12.2022.
//  Copyright © 2022 Nikita Moshyn. All rights reserved.
//

import Foundation
import UIKit

class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    private let accessKey = "366b5e641e9c49788bc230259220712"
    private let rootUrl = "https://api.weatherapi.com/v1/"
    // Request with your current location
    func request<T: Decodable>(lat: Double, lon: Double, completion: @escaping (Result<T, Error>) -> Void) {
        baseRequest(urlString: "https://api.weatherapi.com/v1/forecast.json?key=\(accessKey)&q=\(lat),\(lon)&days=3&aqi=yes&alerts=no", completion: completion)
    }
    // Request to search location in real time
    func request<T: Decodable>(searchLocation: String, completion: @escaping (Result<T, Error>) -> Void) {
        baseRequest(urlString: "https://api.weatherapi.com/v1/search.json?key=\(accessKey)&q=\(searchLocation)", completion: completion)
    }
    // Request from CoreData
    func request<T: Decodable>(search: String, completion: @escaping (Result<T, Error>) -> Void) {
        baseRequest(urlString: "https://api.weatherapi.com/v1/forecast.json?key=\(accessKey)&q=\(search)&days=3&aqi=yes&alerts=no", completion: completion)
    }
    
    private func baseRequest<T: Decodable>(urlString: String, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
            print("URL Request has been sent")
            if let error = error {
                print("Something went wrong in NetworkManager")
                completion(.failure(error))
                return
            }
            guard let data = data else { return }
            do {
                let json = try JSONDecoder().decode(T.self, from: data)
                print("NetworkManager | JSONDecoer success ")
                completion(.success(json))
                return
            } catch {
                completion(.failure(error))
                print("NetworkManagerError | JSONDecoder error \(error)")
            }
        }).resume()
    }
}
