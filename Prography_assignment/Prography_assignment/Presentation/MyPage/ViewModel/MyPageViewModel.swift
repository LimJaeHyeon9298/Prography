//
//  MyPageViewModel.swift
//  Prography_assignment
//
//  Created by 임재현 on 2/17/25.
//

import SwiftUI

class MyPageViewModel: ObservableObject {
    private let dataManager: DataManager
    @Published var shouldRefreshReviews = false
    
    @Published var reviews: [MovieReview] = []
    
    init(dataManager: DataManager) {
        self.dataManager = dataManager
    }
    
    func fetchReviews() {
        do {
            reviews = try dataManager.fetchAllReviews()
        } catch {
            print("Error fetching reviews: \(error)")
        }
    }
    
    func deleteReview(_ review: MovieReview) {
        do {
            try dataManager.deleteReview(movieId: review.movieId)
            // 삭제 후 즉시 reviews 배열 업데이트
            reviews.removeAll { $0.movieId == review.movieId }
            shouldRefreshReviews = true
            DispatchQueue.main.async { [weak self] in
                            self?.shouldRefreshReviews = false
                        }
        } catch {
            print("Error deleting review: \(error)")
        }
    }
}
