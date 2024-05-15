//
//  MarvelAPI.swift
//  MarvelApp
//
//  Created by Marco Alonso Rodriguez on 14/05/24.
//

import Foundation
import Alamofire
import CryptoSwift

class MarvelAPI {
    static let shared = MarvelAPI()
    private let baseURL = "https://gateway.marvel.com/v1/public"
    private let publicKey = "ee595f315cebeebdfbcc430945bff9d6"
    private let privateKey = "c5c0bd4ba81c3083dfacbfd1ce0d25300cf7d85c"
    private let ts = "1"
    
    private var hash: String {
        return "\(ts)\(privateKey)\(publicKey)".md5()
    }
    
    func fetchCharacters(completion: @escaping (Result<[Character], Error>) -> Void) {
            let urlString = "\(baseURL)/characters?apikey=\(publicKey)&ts=\(ts)&hash=\(hash)&limit=50"
            guard let url = URL(string: urlString) else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
                return
            }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
        
                if let error = error {
                    print("DEBUG: error \(error)")
                    completion(.failure(error))
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    print("DEBUG: response \(response)")
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])))
                    return
                }

                guard let data = data else {
                    print("DEBUG: data \(data)")
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                    return
                }

                do {
                    let decoder = JSONDecoder()
                    let userResponse = try decoder.decode(MarvelResponse.self, from: data)
                    let characters = userResponse.data.results
                    print("DEBUG: characters \(characters.count)")
                    completion(.success(characters))
                } catch let error {
                    print("DEBUG: error \(error)")
                    completion(.failure(error))
                }
            }

            task.resume()
        }
}
