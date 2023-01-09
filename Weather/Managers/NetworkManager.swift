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
    
//    static func getUrl(for request: RequestType) -> URL? {
//        switch request {
//        case .todayDate:
//            return URL(string: "https://api.weatherapi.com/v1/current.json?key=\(accessKey)&q=\(MainViewController.lat ?? 0),\(MainViewController.long ?? 0)&aqi=yes")
//        case .searchDate:
//            return URL(string: rootUrl + "\(request.rawValue).json?key=\(accessKey)&q=\(MainViewController.lat ?? 0),\(MainViewController.long ?? 0)&aqi=yes")
//        }
//        
//    }
    
    func request<T: Decodable>(lat: Double, lon: Double, completion: @escaping (Result<T, Error>) -> Void) {
        baseRequest(urlString: "https://api.weatherapi.com/v1/forecast.json?key=\(accessKey)&q=\(lat),\(lon)&days=3&aqi=yes&alerts=no", completion: completion)
    }
    
    func request<T: Decodable>(search: String, completion: @escaping (Result<T, Error>) -> Void) {
        baseRequest(urlString: "https://api.weatherapi.com/v1/forecast.json?key=\(accessKey)&q=\(search)&days=10&aqi=yes&alerts=no", completion: completion)
    }
    
    private func baseRequest<T: Decodable>(urlString: String, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
            print("URL Request has been sent")
            // Validation
            if let error = error {
                print("Something went wrong in NetworkManager")
                completion(.failure(error))
                return
            }
            
            guard let data = data else { return }
            do {
               let json = try JSONDecoder().decode(T.self, from: data)
                print("NetworkManager | JSONDecoer success \(json)")
                completion(.success(json))
                return
                
            }
            catch {
                completion(.failure(error))
                print("NetworkManagerError | JSONDecoder error \(error)")
            }
        }).resume()
    }
    
    //    static func decode() {
    //        DispatchQueue.main.async {
    //            let request = request(for: .todayDate) { data?, error? in
    //
    //            }
    //
    //            let json: Weather?
    //            do {
    //                json = try JSONDecoder().decode(Weather.self, from: data)
    //                print("Decoder ")
    //            }
    //            catch {
    //                print("Decoder error - \(error)")
    //            }
    //
    //            guard let result = json else {
    //                return print("Decoder error: - result is nil")
    //            }
    //            goData = result
    //        }
    //    }
}
extension NetworkManager {
    enum RequestType: String {
        case todayDate
        case searchDate
        
    }
}

