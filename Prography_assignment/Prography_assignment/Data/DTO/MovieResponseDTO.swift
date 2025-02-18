//
//  MovieResponseDTO.swift
//  Prography_assignment
//
//  Created by 임재현 on 2/18/25.
//

import Foundation

struct MovieResponseDTO: Decodable {
    let dates: DatesDTO
    let page: Int
    let results: [MovieDTO]
    let totalPages: Int
    let totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case dates,page,results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct DatesDTO: Decodable {
    let maximum: String
    let minimum: String
}

struct MovieDTO: Decodable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let releaseDate: String
    let voteAverage: Double
    
    enum CodingKeys: String, CodingKey {
        case id, title, overview
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
    }
}
