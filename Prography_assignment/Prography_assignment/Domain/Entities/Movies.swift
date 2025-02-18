//
//  Movies.swift
//  Prography_assignment
//
//  Created by 임재현 on 2/17/25.
//

import SwiftUI

struct Movies {

}

struct MovieDomain {
    let id: Int
    let title: String
    let overview: String
    let posterURL: URL?
    let releaseDate: Date
    let rating: Double
}

struct MovieListDomain {
    let movies: [MovieDomain]
    let currentPage: Int
    let totalPages: Int
    let availableDateRange: DateRange
}

struct DateRange {
    let from: Date
    let to: Date
}

