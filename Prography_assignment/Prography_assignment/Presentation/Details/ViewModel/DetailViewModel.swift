//
//  DetailViewModel.swift
//  Prography_assignment
//
//  Created by 임재현 on 2/17/25.
//

import SwiftUI
import Combine

class DetailViewModel: ObservableObject {
    private let movieId: Int
    private let useCase: MovieDetailUseCaseProtocol
    private var cancellables = Set<AnyCancellable>()
    
    // Published 프로퍼티
    @Published private(set) var movieDetail: MovieDetailDomain?
    @Published private(set) var isLoading = false
    @Published private(set) var error: NetworkError?
    
    init(movieId: Int, useCase: MovieDetailUseCaseProtocol) {
        self.movieId = movieId
        self.useCase = useCase
    }
    
    func fetchMovieDetail() {
        isLoading = true
        error = nil
        
        useCase.execute(movieId: movieId)
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
        movieDetail?.genres ?? []
    }
}
