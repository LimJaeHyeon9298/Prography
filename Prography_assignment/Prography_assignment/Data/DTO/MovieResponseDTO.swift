//
//  MovieResponseDTO.swift
//  Prography_assignment
//
//  Created by 임재현 on 2/18/25.
//

import Foundation

struct MovieResponseDTO: Decodable {
    let dates: DatesDTO?  // Optional로 변경
    let page: Int
    let results: [MovieDTO]
    let totalPages: Int
    let totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case dates
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct MovieDTO: Decodable {
    let id: Int
    let title: String
    let originalTitle: String?
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    let releaseDate: String
    let voteAverage: Double
    let voteCount: Int?
    let popularity: Double?
    let genreIds: [Int]
    let originalLanguage: String?
    let adult: Bool?
    let video: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case originalTitle = "original_title"
        case overview
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case popularity
        case genreIds = "genre_ids"
        case originalLanguage = "original_language"
        case adult
        case video
    }
}

//struct MovieResponseDTO: Decodable {
//    let dates: DatesDTO?
//    let page: Int
//    let results: [MovieDTO]
//    let totalPages: Int
//    let totalResults: Int
//    
//    enum CodingKeys: String, CodingKey {
//        case dates,page,results
//        case totalPages = "total_pages"
//        case totalResults = "total_results"
//    }
//}

struct DatesDTO: Decodable {
    let maximum: String
    let minimum: String
}
//
//struct MovieDTO: Decodable {
//    let id: Int
//    let title: String
//    let overview: String
//    let posterPath: String?
//    let releaseDate: String
//    let voteAverage: Double
//    let genreIds: [Int]
//    
//    enum CodingKeys: String, CodingKey {
//        case id, title, overview
//        case posterPath = "poster_path"
//        case releaseDate = "release_date"
//        case voteAverage = "vote_average"
//        case genreIds = "genre_ids"
//    }
//}


struct PopularMovieResponseDTO: Decodable {
    let page: Int
    let results: [MovieDTO]
    let totalPages: Int
    let totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct TopRatedMovieResponseDTO: Decodable {
    let page: Int
    let results: [TopRatedMovieDTO]
    let totalPages: Int
    let totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct TopRatedMovieDTO: Decodable {
    let id: Int
    let title: String
    let originalTitle: String
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    let releaseDate: String
    let voteAverage: Double
    let voteCount: Int
    let popularity: Double
    let genreIds: [Int]
    let originalLanguage: String
    let adult: Bool
    let video: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case originalTitle = "original_title"
        case overview
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case popularity
        case genreIds = "genre_ids"
        case originalLanguage = "original_language"
        case adult
        case video
    }
}

struct GenreDTO: Decodable {
    let id: Int
    let name: String
}



struct MovieDetailDTO: Decodable {
    let id: Int
    let title: String
    let originalTitle: String
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    let voteAverage: Double
    let voteCount: Int
    let genres: [GenreDTO]
    let runtime: Int?
    let releaseDate: String
    let status: String
    let tagline: String?
    let popularity: Double
    let originalLanguage: String
    let productionCompanies: [ProductionCompanyDTO]
    let productionCountries: [ProductionCountryDTO]
    
    enum CodingKeys: String, CodingKey {
        case id, title, overview, runtime, status, tagline, popularity, genres
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case originalTitle = "original_title"
        case releaseDate = "release_date"
        case originalLanguage = "original_language"
        case productionCompanies = "production_companies"
        case productionCountries = "production_countries"
    }
}

// 추가로 필요한 DTO들
struct ProductionCompanyDTO: Decodable {
    let id: Int
    let name: String
    let logoPath: String?
    let originCountry: String
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case logoPath = "logo_path"
        case originCountry = "origin_country"
    }
}

struct ProductionCountryDTO: Decodable {
    let iso3166_1: String
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case iso3166_1 = "iso_3166_1"
        case name
    }
}
