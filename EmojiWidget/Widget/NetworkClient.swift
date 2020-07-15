//
//  NetworkClient.swift
//  iOS14-Widget
//
//  Created by Andrea Stevanato on 15/07/2020.
//

import Foundation

final class NetworkClient {
    
    private let session: URLSession = .shared

    enum NetworkError: Error {
        case noData
    }

    public init() { }

    func executeRequest(request: URLRequest, completion: @escaping (Result<Data, Error>) -> Void) {
        session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            completion(.success(data))
        }.resume()
    }
}
