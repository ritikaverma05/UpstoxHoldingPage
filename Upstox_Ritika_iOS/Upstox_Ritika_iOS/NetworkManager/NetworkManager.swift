//
//  NetworkManager.swift
//  Upstox_Ritika_iOS
//
//  Created by Ritika Verma on 11/03/24.
//

import Foundation

protocol NetworkManagerProtocol {
    func getResponseList<T: Codable>(path: String?, resultType: T.Type, completion: @escaping (Result<T, NetworkError>) -> Void)
}

final class NetworkManager: NetworkManagerProtocol {
    
    func getResponseList<T: Codable>(path: String?, resultType: T.Type, completion: @escaping (Result<T, NetworkError>) -> Void) {
        
        guard let urlPath = path, let url = URL(string: urlPath) else {
            completion(.failure(.invalidUrl))
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(.requestFailed(error)))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode) else {
                completion(.failure(.invalidResponse))
                return
            }
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            do {
                let items = try JSONDecoder().decode(T.self, from: data)
                completion(.success(items))
            } catch {
                completion(.failure(.decodingError(error)))
            }
        }.resume()
    }
    
}

enum NetworkError: Error {
    case invalidUrl
    case invalidResponse
    case invalidData
    case requestFailed(Error)
    case decodingError(Error)
}

