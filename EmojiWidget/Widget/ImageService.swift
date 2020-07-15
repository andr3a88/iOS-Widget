//
//  ImageService.swift
//  WidgetExtension
//
//  Created by Andrea Stevanato on 15/07/2020.
//

import Foundation
import UIKit

struct ImageService {
    static func getImage(text: String, client: NetworkClient, completion: ((_ image: UIImage) -> Void)? = nil) {
        runImageRequest(.imageRequest("140x300.png?text=\(text)"), on: client, completion: completion)
    }

    static func runImageRequest(_ request: URLRequest, on client: NetworkClient, completion: ((_ image: UIImage) -> Void)? = nil) {
        client.executeRequest(request: request) { result in
            switch result {
            case .success(let data):

                if let image = UIImage(data: data) {
                    completion?(image)
                } else {
                    print("Cannot get image")
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension URLRequest {
    
    private static var baseURL: String { "https://via.placeholder.com/" }

    public static func imageRequest(_ path: String) -> URLRequest {
        .init(endpoint: path)
    }

    init(endpoint: String...) {
        guard let url = URL(string: Self.baseURL + "/" + endpoint.joined(separator: "/")) else {
            preconditionFailure("Expected a valid URL")
        }
        self.init(url: url)
    }
}

extension Date {

    /// Convert date into a string
    ///
    /// - Parameter format: format, default is "dd MMMM yyyy - HH:mm"
    /// - Returns: date into a string
    func toString(format: String = "HH:mm") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
