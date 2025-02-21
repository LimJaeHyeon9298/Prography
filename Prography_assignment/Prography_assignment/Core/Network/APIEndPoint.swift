//
//  APIEndPoint.swift
//  Prography_assignment
//
//  Created by 임재현 on 2/17/25.
//

import SwiftUI

enum APIEndPoint{
    case nowPlaying(page:Int, language:String,region:String?)
    case popular(page:Int, language:String,region:String?)
    case topRated(page:Int, language:String,region:String?)
    
    var baseURL: String {
        return "https://api.themoviedb.org/3"
    }
    
    var path:String {
        switch self {
        case .nowPlaying:
            return "/movie/now_playing"
        case .popular:
            return "/movie/popular"
        case .topRated:
            return "/movie/top_rated"
        }
    }
    
    var queryItems: [URLQueryItem] {
            switch self {
            case .nowPlaying(let page, let language, let region),
                 .popular(let page, let language, let region),
                 .topRated(let page, let language, let region):
                var items = [
                    URLQueryItem(name: "page", value: "\(page)"),
                    URLQueryItem(name: "language", value: language)
                ]
                if let region = region {
                    items.append(URLQueryItem(name: "region", value: region))
                }
                return items
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
    
    init?(number: Int) {
        guard number > 0, number <= 500 else { return nil }
        self.number = number
    }
}

struct CommonQureyParameters {
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
