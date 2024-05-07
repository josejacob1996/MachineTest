//
//  ServiceHelper.swift
//  iOS Test
//
//  Created by Jose Jacob on 07/05/24.
//

import Foundation
let baseUrl = "https://acharyaprashant.org/api/v2"

enum DataError: Error {
    case invalidURL
    
    var localizedDescription:String{
        switch self {
        case .invalidURL:
            return "URL is invalid"
        }
    }
}

enum ApiMethod: String {
    case GET
    case POST
    case PUT
    case DELETE
}
enum AcceptHeader: String {
    case json = "application/json"
}


typealias EndPoint = (endPoind:String, method:ApiMethod, acceptHeader:AcceptHeader)

class ServiceManager{
    static let shared = ServiceManager()
    
    func fetch<T : Decodable>(
        endPoint: EndPoint,
        type: T.Type,
        withCompletion completion: @escaping (Result<T,Error>) -> Void) {
            guard let url = URL(string: "\(baseUrl)/\(endPoint.endPoind)") else{
                DispatchQueue.main.async { completion(.failure(DataError.invalidURL)) }
                return
            }
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = endPoint.method.rawValue
            urlRequest.addValue(endPoint.acceptHeader.rawValue, forHTTPHeaderField: "Content-Type")
            URLSession.shared.dataTask(with: urlRequest) { data, _, error in
                if let error = error { completion(.failure(error)); return }
                do {
                    let response = try JSONDecoder().decode(T.self, from: data!)
                    dump(response)
                    DispatchQueue.main.async { completion(.success(response)) }
                } catch {
                    DispatchQueue.main.async { completion(.failure(error)) }
                }
            }.resume()
    }
}
