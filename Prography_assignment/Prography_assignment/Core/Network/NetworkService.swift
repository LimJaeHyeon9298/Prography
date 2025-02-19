//
//  NetworkService.swift
//  Prography_assignment
//
//  Created by 임재현 on 2/17/25.
//

import Combine
import Foundation

protocol NetworkServiceProtocol {
    func request<T:Decodable>(_ endPoint:APIEndPoint,accessToken:String) -> AnyPublisher<T, NetworkError>
}

struct NetworkService: NetworkServiceProtocol {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
            self.session = session
        }
    
    func request<T: Decodable>(_ endpoint: APIEndPoint, accessToken: String) -> AnyPublisher<T, NetworkError> {
            guard var components = URLComponents(string: endpoint.baseURL + endpoint.path) else {
                return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
            }
            
            components.queryItems = endpoint.queryItems
            
            guard let url = components.url else {
                return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
            }
            
            var request = URLRequest(url: url)
            request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
            request.addValue("application/json", forHTTPHeaderField: "accept")
        
        print("Request URL:", url)
        print("Request Headers:", request.allHTTPHeaderFields)
            print("Authorization Token:", "Bearer \(accessToken)")
            
            return session.dataTaskPublisher(for: request)
                .mapError { NetworkError.networkError($0) }
                .flatMap { data, response -> AnyPublisher<T, NetworkError> in
                    guard let httpResponse = response as? HTTPURLResponse else {
                        return Fail(error: NetworkError.invalidResponse).eraseToAnyPublisher()
                    }
                    
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

