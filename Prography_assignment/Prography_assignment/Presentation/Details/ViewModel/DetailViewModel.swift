//
//  DetailViewModel.swift
//  Prography_assignment
//
//  Created by 임재현 on 2/17/25.
//

import SwiftUI
import Combine

class DetailViewModel: ObservableObject {
     let movieId: Int
    private let reviewStore: ReviewStore
    @Published var showingSaveAlert = false
    @Published var showingDeleteAlert = false
    
    private let detailUseCase: MovieDetailUseCaseProtocol
    private var cancellables = Set<AnyCancellable>()
    
    @Published var isEditing = false
    @Published var showingDeleteConfirmation = false
    
    // Published 프로퍼티
    @Published private(set) var movieDetail: MovieDetailDomain?
    @Published private(set) var isLoading = false
    @Published private(set) var error: NetworkError?
    
    @Published var existingReview: MovieReview?
    @Published var hasExistingReview: Bool = false
    @Published var userRating: Int = 0
    @Published var comment: String = ""

    
    init(movieId: Int, detailUseCase: MovieDetailUseCaseProtocol,reviewStore: ReviewStore) {
        self.movieId = movieId
        self.detailUseCase = detailUseCase
        self.reviewStore = reviewStore
    }
    
    func deleteReview() {
        do {
            // Use DataManager to delete the review for this specific movie
            try DataManager.shared.deleteReview(movieId: movieId)
            
            // Reset review-related properties
            hasExistingReview = false
            comment = ""
            userRating = 0
            
            // Optionally, show a success message or perform additional UI updates
            showingDeleteAlert = true  // Assuming you want to show an alert
        } catch {
            // Handle any errors that might occur during deletion
            print("Error deleting review: \(error.localizedDescription)")
            // Optionally, show an error alert to the user
            // errorMessage = "리뷰 삭제에 실패했습니다."
            // showingErrorAlert = true
        }
    }
    
    func fetchMovieDetail() {
        isLoading = true
        error = nil
        
        detailUseCase.execute(movieId: movieId)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.error = error
                }
            } receiveValue: { [weak self] movieDetail in
                self?.movieDetail = movieDetail
            }
            .store(in: &cancellables)
    }
    
    func checkExistingReview() {
        reviewStore.loadReviews()
         if let review = reviewStore.reviews.first(where: { $0.movieId == movieId }) {
             existingReview = review
             hasExistingReview = true
             userRating = review.rating
             comment = review.comment
         }
     }
     
    func saveReview(title:String, rating: Int, comment: String) {
         do {
             try DataManager.shared.saveReview(
                movieId: movieId,
                 title: title,
                 rating: rating,
                 comment: comment,
                 posterURL: posterURL?.absoluteString ?? ""
             )
             reviewStore.loadReviews()
             
             hasExistingReview = true
             existingReview = reviewStore.reviews.first(where: { $0.movieId == movieId })
            showingSaveAlert = true
         } catch {
             print("Error saving review: \(error)")
         }
     }
    
    // View에서 필요한 computed properties
    var title: String {
        movieDetail?.title ?? ""
    }
    
    var overview: String {
        movieDetail?.overview ?? ""
    }
    
    var rating: Double {
        movieDetail?.rating ?? 0.0
    }
    
    var posterURL: URL? {
        movieDetail?.posterURL
    }
    
    var genres: [String] {
        return movieDetail?.genres.map { $0.name } ?? []
    }
}


extension DetailViewModel {
    func updateReview(title: String, rating: Int, comment: String) {
          do {
              try DataManager.shared.updateReview(
                  movieId: movieId,
                  newRating: rating,
                  newComment: comment
              )
              
              isEditing = false
              showingSaveAlert = true
              
              // 필요하다면 UI 상태 업데이트
              userRating = rating
              self.comment = comment
          } catch {
              print("리뷰 업데이트 실패: \(error)")
          }
      }
}
