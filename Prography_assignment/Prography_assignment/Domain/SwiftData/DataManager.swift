//
//  DataManager.swift
//  Prography_assignment
//
//  Created by 임재현 on 2/20/25.
//

import SwiftUI
import SwiftData

class DataManager {
    static let shared = DataManager()
    private(set) var modelContext: ModelContext!
    
    func setModelContext(_ context: ModelContext) {
        self.modelContext = context
    }
    
    // 리뷰 저장 함수
    func saveReview(movieId: Int,title:String, rating: Int, comment: String,posterURL: String) throws {
        guard let context = modelContext else {
            throw NSError(domain: "DataManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "ModelContext not initialized"])
        }
        
        let review = MovieReview(movieId: movieId,title: title, rating: rating, comment: comment,posterURL: posterURL)
        context.insert(review)
        
        try context.save()
    }
    
    func fetchReviews(for movieId: Int) throws -> [MovieReview] {
        let descriptor = FetchDescriptor<MovieReview>(
            predicate: #Predicate<MovieReview> { review in
                review.movieId == movieId
            }
        )
        let reviews = try modelContext.fetch(descriptor)
        
        // 저장된 내용 출력
        reviews.forEach { review in
            print("Movie ID: \(review.movieId)")
            print("Rating: \(review.rating)")
            print("Comment: \(review.comment)")
            print("Created At: \(review.createdAt)")
            print("PosterURL: \(review.posterURL)")
            print("---------------")
        }
        
        return reviews
    }
    
    func updateReview(movieId: Int, newRating: Int, newComment: String) throws {
           let descriptor = FetchDescriptor<MovieReview>(
               predicate: #Predicate<MovieReview> { review in
                   review.movieId == movieId
               }
           )
           let review = try modelContext.fetch(descriptor).first
           
           if let review = review {
               review.rating = newRating
               review.comment = newComment
               try modelContext.save()
           }
       }
       
       // 삭제 함수
       func deleteReview(movieId: Int) throws {
           let descriptor = FetchDescriptor<MovieReview>(
               predicate: #Predicate<MovieReview> { review in
                   review.movieId == movieId
               }
           )
           let review = try modelContext.fetch(descriptor).first
           
           if let review = review {
               modelContext.delete(review)
               try modelContext.save()
           }
       }
    
    func fetchAllReviews() throws -> [MovieReview] {
        // 모든 MovieReview를 가져오는 기본 FetchDescriptor 생성
        let descriptor = FetchDescriptor<MovieReview>()
        
        // 모든 리뷰를 최신순으로 정렬 (선택적)
        let sortedDescriptor = FetchDescriptor<MovieReview>(
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        
        // 모든 리뷰 가져오기
        let reviews = try modelContext.fetch(sortedDescriptor)
        
        // 저장된 내용 출력 (옵션)
        reviews.forEach { review in
            print("Movie ID: \(review.movieId)")
            print("Title: \(review.title)")
            print("Rating: \(review.rating)")
            print("Comment: \(review.comment)")
            print("Created At: \(review.createdAt)")
            print("PosterURL: \(review.posterURL)")
            print("---------------")
        }
        
        return reviews
    }
}


struct testView: View {
    var body: some View {
        Button("리뷰 수정") {
            do {
                try DataManager.shared.updateReview(
                    movieId: 939243,
                    newRating: 4,
                    newComment: "수정된 코멘트입니다"
                )
            } catch {
                print("Error updating review: \(error)")
            }
        }
        
        Button("리뷰 삭제") {
            do {
                try DataManager.shared.deleteReview(movieId: 939243)
            } catch {
                print("Error deleting review: \(error)")
            }
        }
    }
}
