//
//  NetworkService.swift
//  Prography_assignment
//
//  Created by 임재현 on 2/17/25.
//

import Combine
import Foundation
import SwiftUI

protocol NetworkServiceProtocol {
    func request<T:Decodable>(_ endPoint:APIEndPoint,
                              accessToken:String,
                              environment:Environment) -> AnyPublisher<T, NetworkError>
}

protocol URLSessionProtocol {
    func dataTaskPublisher(for request: URLRequest) -> AnyPublisher<(Data, URLResponse), Error>
}

extension URLSession: URLSessionProtocol {
    func dataTaskPublisher(for request: URLRequest) -> AnyPublisher<(Data, URLResponse), Error> {
        return self.dataTaskPublisher(for: request)
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}

struct NetworkService: NetworkServiceProtocol {
    private let session: URLSessionProtocol
    private let logger: NetworkLogging
    private let timeoutInterval: TimeInterval
    
    init(session: URLSession = .shared,
         logger: NetworkLogging = DefaultNetworkLogging(),
         timeoutInterval: TimeInterval = 30) {
            self.session = session
            self.logger = logger
            self.timeoutInterval = timeoutInterval
        }
    
    func request<T: Decodable>(_ endpoint: APIEndPoint,
                               accessToken: String,
                               environment:Environment) -> AnyPublisher<T, NetworkError> {
        guard var components = URLComponents(string: environment.baseURL + endpoint.path) else {
                return Fail(error: NetworkError.invalidURL("Invalid base URL or path"))
                    .eraseToAnyPublisher()
            }
            
            components.queryItems = endpoint.queryItems
            
            guard let url = components.url else {
                return Fail(error: NetworkError
                    .invalidURL("Could not construct URL from components"))
                    .eraseToAnyPublisher()
            }
            
            var request = URLRequest(url: url)
            request.timeoutInterval = timeoutInterval
            request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
            request.addValue("application/json", forHTTPHeaderField: "accept")
        
            logger.log(request: request)
        
       
            
            return session.dataTaskPublisher(for: request)
                .mapError { NetworkError.networkError($0) }
                .flatMap { data, response -> AnyPublisher<T, NetworkError> in
                    guard let httpResponse = response as? HTTPURLResponse else {
                        return Fail(error: NetworkError.invalidResponse).eraseToAnyPublisher()
                    }
                    logger.log(response: httpResponse, data: data)
                    
                    guard (200...299).contains(httpResponse.statusCode) else {
                        
                        let message = String(data: data, encoding: .utf8)
                        return Fail(error: NetworkError.from(
                            statusCode: httpResponse.statusCode,
                            message: message
                        ))
                        .eraseToAnyPublisher()
                    }
                    
                    return Just(data)
                        .decode(type: T.self, decoder: JSONDecoder())
                        .mapError { NetworkError.decodingError($0) }
                        .eraseToAnyPublisher()
                }
                .eraseToAnyPublisher()
        }
    

}

