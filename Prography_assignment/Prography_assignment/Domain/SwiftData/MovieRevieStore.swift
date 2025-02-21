//
//  MovieRevieStore.swift
//  Prography_assignment
//
//  Created by 임재현 on 2/21/25.
//

import SwiftUI
import SwiftData


class ReviewStore: ObservableObject {
    @Published var reviews: [MovieReview] = []
    
    func loadReviews() {
        do {
            let descriptor = FetchDescriptor<MovieReview>()
            reviews = try DataManager.shared.modelContext.fetch(descriptor)
        } catch {
            print("Error fetching reviews: \(error)")
        }
    }
}
