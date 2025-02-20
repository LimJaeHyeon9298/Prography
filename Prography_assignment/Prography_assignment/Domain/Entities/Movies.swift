//
//  Movies.swift
//  Prography_assignment
//
//  Created by 임재현 on 2/17/25.
//

import SwiftUI

struct Movies {

}

struct MovieDomain: Equatable,Hashable {
    let id: Int
    let title: String
    let overview: String
    let posterURL: URL?
    let releaseDate: Date
    let rating: Double
}

struct MovieListDomain: Equatable {
    let movies: [MovieDomain]
    let currentPage: Int
    let totalPages: Int
    let availableDateRange: DateRange
}

struct DateRange: Equatable {
    let from: Date
    let to: Date
}


struct PopularMovieListDomain: Equatable {
    let movies: [MovieDomain]
    let currentPage: Int
    let totalPages: Int
}

struct TopRatedMovieListDomain: Equatable {
    let page: Int
    let movies: [TopRatedMovieDomain]
    let totalPages: Int
    let totalResults: Int
}

struct TopRatedMovieDomain: Equatable {
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
}
