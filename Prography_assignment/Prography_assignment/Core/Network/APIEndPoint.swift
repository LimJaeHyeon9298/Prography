//
//  APIEndPoint.swift
//  Prography_assignment
//
//  Created by 임재현 on 2/17/25.
//

import SwiftUI

enum APIEndPoint{
    case nowPlaying(page: Page, parameters: CommonQueryParameters)
    case popular(page: Page, parameters: CommonQueryParameters)
    case topRated(page: Page, parameters: CommonQueryParameters)
    case details(movieID: Int, parameters: CommonQueryParameters)

    var path:String {
        switch self {
        case .nowPlaying:
            return "/movie/now_playing"
        case .popular:
            return "/movie/popular"
        case .topRated:
            return "/movie/top_rated"
        case .details(let movieID, _):
            return "/movie/\(movieID)"
        }
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .nowPlaying(let page, let parameters),
             .popular(let page, let parameters),
             .topRated(let page, let parameters):
            var items = parameters.queryItems
            items.append(URLQueryItem(name: "page", value: "\(page.number)"))
            return items
            
        case .details(_, let parameters):
            return parameters.queryItems
        }
    }
    
}

enum Environment {
    case development
    case production
    
    var baseURL: String {
        switch self {
        case .development:
            return "https://api.themoviedb.org/3"
        case .production:
            return "https://api.themoviedb.org/3"
        }
    }
}

struct Page {
    let number: Int
    
    init?(_ number: Int) {
        guard number > 0, number <= 500 else { return nil }
        self.number = number
    }
}

struct CommonQueryParameters {
    let language: String
    let region: String?
    
    var queryItems: [URLQueryItem] {
        var items = [URLQueryItem(name: "language", value: language)]
        if let region = region {
            items.append(URLQueryItem(name: "region", value: region))
        }
        return items
    }
}
