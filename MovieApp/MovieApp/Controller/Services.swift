//
//  Services.swift
//  MovieApp
//
//  Created by ayan on 17.12.2025.
//

import Foundation
import Alamofire

class Services {
    
    static let shared = Services()
    private init() {}
    
    func searchMovies(query: String, completion: @escaping (Result<[Movie], Error>) -> Void) {
        print("🔹 Starting movie search for query: \(query)")
        
        let parameters: Parameters = [
            "q": query
        ]
        
        print("🔹 Request URL: \(API.baseURL)")
        print("🔹 Parameters: \(parameters)")
        
        AF.request(API.baseURL, parameters: parameters)
            .validate()
            .responseDecodable(of: MoviesResponse.self) { response in
                
                print("🔹 Alamofire response received")
                
                switch response.result {
                case .success(let moviesResponse):
                    print("✅ Successfully decoded movies: \(moviesResponse.search.count) found")
                    completion(.success(moviesResponse.search))
                case .failure(let error):
                    print("❌ Failed to fetch movies: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
    }
}

enum API {
    static let baseURL = "https://imdb.iamidiotareyoutoo.com/search?"
    static let apiKey = "74d6050c"
}
