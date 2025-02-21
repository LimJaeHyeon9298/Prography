//
//  Movies.swift
//  Prography_assignment
//
//  Created by 임재현 on 2/17/25.
//

import SwiftUI

struct Movies {

}

struct DateRange: Equatable {
    let from: Date
    let to: Date
}



enum MovieGenre: Int,CaseIterable {
    case action = 28
    case adventure = 12
    case animation = 16
    case comedy = 35
    case crime = 80
    case documentary = 99
    case drama = 18
    case family = 10751
    case fantasy = 14
    case history = 36
    case horror = 27
    case music = 10402
    case mystery = 9648
    case romance = 10749
    case scienceFiction = 878
    case tvMovie = 10770
    case thriller = 53
    case war = 10752
    case western = 37
    
    var name: String {
        switch self {
        case .action: return "액션"
        case .adventure: return "모험"
        case .animation: return "애니메이션"
        case .comedy: return "코미디"
        case .crime: return "범죄"
        case .documentary: return "다큐멘터리"
        case .drama: return "드라마"
        case .family: return "가족"
        case .fantasy: return "판타지"
        case .history: return "역사"
        case .horror: return "공포"
        case .music: return "음악"
        case .mystery: return "미스터리"
        case .romance: return "로맨스"
        case .scienceFiction: return "SF"
        case .tvMovie: return "TV 영화"
        case .thriller: return "스릴러"
        case .war: return "전쟁"
        case .western: return "서부"
        }
    }
}

struct MovieListDomain: Equatable {
    let movies: [MovieDomain]
    let currentPage: Int
    let totalPages: Int
    let totalResults: Int?
    let availableDateRange: DateRange?
}

//struct MovieDomain: Equatable, Hashable {
//    let id: Int
//    let title: String
//    let originalTitle: String?
//    let overview: String
//    let posterPath: String?
//    let backdropPath: String?
//    let releaseDate: Date?
//    let rating: Double
//    let voteCount: Int?
//    let popularity: Double?
//    let genreIds: [Int]
//    let originalLanguage: String?
//    let adult: Bool?
//    let video: Bool?
//    
//    // Computed properties for convenience
//    var posterURL: URL? {
//        guard let posterPath = posterPath else { return nil }
//        return URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
//    }
//    
//    // Genre mapping convenience method
//    func getGenreNames() -> [String] {
//        return genreIds.compactMap { genreId in
//            MovieGenre(rawValue: genreId)?.name
//        }
//    }
//}
struct MovieDomain: Equatable, Hashable {
    let id: Int
    let title: String
    let originalTitle: String?
    let overview: String
    let posterURL: URL?
    let backdropURL: URL?
    let releaseDate: Date?
    let rating: Double
    let voteCount: Int?
    let popularity: Double?
    let genreIds: [Int]
    let originalLanguage: String?
    let adult: Bool?
    let video: Bool?
    
    // Computed properties for URLs
    init(
        id: Int,
        title: String,
        originalTitle: String?,
        overview: String,
        posterPath: String?,
        backdropPath: String?,
        releaseDate: Date?,
        rating: Double,
        voteCount: Int?,
        popularity: Double?,
        genreIds: [Int],
        originalLanguage: String?,
        adult: Bool?,
        video: Bool?
    ) {
        self.id = id
        self.title = title
        self.originalTitle = originalTitle
        self.overview = overview
        self.posterURL = posterPath.flatMap { URL(string: "https://image.tmdb.org/t/p/w500/\($0)") }
        self.backdropURL = backdropPath.flatMap { URL(string: "https://image.tmdb.org/t/p/w500/\($0)") }
        self.releaseDate = releaseDate
        self.rating = rating
        self.voteCount = voteCount
        self.popularity = popularity
        self.genreIds = genreIds
        self.originalLanguage = originalLanguage
        self.adult = adult
        self.video = video
    }
}


struct MovieDetailDomain {
    let id: Int
    let title: String
    let originalTitle: String
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    let releaseDate: Date?
    let rating: Double
    let voteCount: Int
    let runtime: Int?
    let status: String
    let tagline: String?
    let popularity: Double
    let genres: [GenreDomain]
    let productionCompanies: [ProductionCompanyDomain]
    let productionCountries: [ProductionCountryDomain]
    
    var posterURL: URL? {
        guard let posterPath = posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
    }
    
    var backdropURL: URL? {
        guard let backdropPath = backdropPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/original\(backdropPath)")
    }
}

struct GenreDomain {
    let id: Int
    let name: String
}

struct ProductionCompanyDomain {
    let id: Int
    let name: String
    let logoPath: String?
    let originCountry: String
}

struct ProductionCountryDomain {
    let iso3166_1: String
    let name: String
}


extension MovieDomain {
    func getGenreNames() -> [String] {
        return genreIds.compactMap { genreId in
            MovieGenre(rawValue: genreId)?.name
        }
    }
}
