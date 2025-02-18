//
//  APIEndPoint.swift
//  Prography_assignment
//
//  Created by 임재현 on 2/17/25.
//

import SwiftUI

enum APIEndPoint{
    case nowPlaying(page:Int, language:String,region:String?)
    
    var baseURL: String {
        return "https://api.themoviedb.org/3"
    }
    
    var path:String {
        switch self {
        case .nowPlaying:
            return "/movie/now_playing"
        }
    }
    
    var queryItems: [URLQueryItem] {
            switch self {
            case .nowPlaying(let page, let language, let region):
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

