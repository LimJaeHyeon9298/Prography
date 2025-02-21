//
//  MovieReview.swift
//  Prography_assignment
//
//  Created by 임재현 on 2/20/25.
//

import SwiftData
import Foundation

@Model
class MovieReview {
    let movieId: Int
    var rating: Int
    var comment: String
    var createdAt: Date
    var posterURL: String
    
    init(movieId: Int, rating: Int, comment: String,posterURL: String) {
        self.movieId = movieId
        self.rating = rating
        self.comment = comment
        self.createdAt = Date()
        self.posterURL = posterURL
    }
}
