//
//  HomeViewModel.swift
//  Prography_assignment
//
//  Created by 임재현 on 2/17/25.
//

import SwiftUI
import Combine


class HomeViewModel: ObservableObject {

    @Published private(set) var movies: MovieListDomain?
    @Published private(set) var isLoading = false
    @Published private(set) var error: NetworkError?
    
    private let useCase: FetchNowPlayingMoviesUseCase
    private var cancellables = Set<AnyCancellable>()
    private var currentPage = 1
    

    init(useCase: FetchNowPlayingMoviesUseCase) {
        self.useCase = useCase
    }
    
    
    func fetchNowPlaying() {
        isLoading = true
        error = nil
        
        useCase.execute(page: currentPage)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .failure(let error):
                    self?.error = error
                case .finished:
                    break
                }
            } receiveValue: { [weak self] movieList in
                self?.movies = movieList
                self?.currentPage += 1
            }
            .store(in: &cancellables)
    }
    
    func loadMoreIfNeeded(currentItem movie: MovieDomain) {
        guard let movies = movies,
              !isLoading,
              currentPage <= movies.totalPages,
              movies.movies.last?.id == movie.id else {
            return
        }
        
        fetchNowPlaying()
    }
    
    func retry() {
        fetchNowPlaying()
    }
}

