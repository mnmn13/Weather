//
//  Condition.swift
//  Weather
//
//  Created by MN on 08.12.2022.
//  Copyright © 2022 Nikita Moshyn. All rights reserved.
//

import Foundation
import UIKit

struct Condition: Codable {
    let text: String?
    let icon: String?
    let code: Int?

    enum CodingKeys: String, CodingKey {
        case text = "text"
        case icon = "icon"
        case code = "code"
    }
//    func test<T: Decodable>(completion: @escaping (Result<T,Error>) -> Void)
    func getImage(handler: @escaping (UIImage?) -> ())  {

        guard let icon = icon else { fatalError() }
        
        if let image = UIImage(systemName: icon) {
            
            handler(image.withTintColor(.systemYellow, renderingMode: .alwaysOriginal))
            return
        }
        
        guard let url = URL(string: "https:" + icon) else { fatalError() }
        
        URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
//            print("Image request has been send")
            
            if let error = error {
                print("Image request \(error)")
                return
            }
            
            guard let data = data else { return }
            handler(UIImage(data: data))
            
        }).resume()
    }
}
