//
//  HomeViewModel.swift
//  Prography_assignment
//
//  Created by 임재현 on 2/17/25.
//

import SwiftUI
import Combine


class HomeViewModel: ObservableObject {

    @Published private(set) var nowPlayingMovies: MovieListDomain?
    @Published private(set) var isLoadingNowPlaying = false
    @Published private(set) var isLoadingPopular = false
    @Published private(set) var nowPlayingError: NetworkError?
    @Published private(set) var popularError: NetworkError?
    @Published private(set) var popularMovies: PopularMovieListDomain?
    
    private let nowPlayingUseCase: FetchNowPlayingMoviesUseCase
    private let popularUseCase: PopularMovieUseCase
    private var cancellables = Set<AnyCancellable>()
    private var nowPlayingCurrentPage = 1
    private var popularCurrentPage = 1
    

    init(nowPlayingUseCase: FetchNowPlayingMoviesUseCase,
         popularUseCase: PopularMovieUseCase) {
        self.nowPlayingUseCase = nowPlayingUseCase
        self.popularUseCase = popularUseCase
    }
    
    
    func fetchNowPlaying() {
        print("fetchNowPlaying 시작")
        isLoadingNowPlaying = true
        nowPlayingError = nil
        
        nowPlayingUseCase.execute(page: nowPlayingCurrentPage)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoadingNowPlaying = false
                switch completion {
                case .failure(let error):
                    self?.nowPlayingError = error
                case .finished:
                    break
                }
            } receiveValue: { [weak self] movieList in
                self?.nowPlayingMovies = movieList
                self?.nowPlayingCurrentPage += 1
            }
            .store(in: &cancellables)
    }
    
    func fetchPopular() {
        print("fetchPopular 시작")
         isLoadingPopular = true
         popularError = nil
         
         popularUseCase.execute(page: popularCurrentPage)
             .receive(on: DispatchQueue.main)
             .sink { [weak self] completion in
                 print("popular completion: \(completion)")
                 self?.isLoadingPopular = false
                 switch completion {
                 case .failure(let error):
                     self?.popularError = error
                     print("popular error: \(error)")
                 case .finished:
                     break
                 }
             } receiveValue: { [weak self] movieList in
                 print("popular 데이터 받음")
                 self?.popularMovies = movieList
                 self?.popularCurrentPage += 1
             }
             .store(in: &cancellables)
     }
    
    func loadMoreNowPlayingIfNeeded(currentItem movie: MovieDomain) {
           guard let movies = nowPlayingMovies,
                 !isLoadingNowPlaying,
                 nowPlayingCurrentPage <= movies.totalPages,
                 movies.movies.last?.id == movie.id else {
               return
           }
           
           fetchNowPlaying()
       }
       
    func loadMorePopularIfNeeded(currentItem movie: MovieDomain) {
           guard let movies = popularMovies,
                 !isLoadingPopular,
                 popularCurrentPage <= movies.totalPages,
                 movies.movies.last?.id == movie.id else {
               return
           }
           
           fetchPopular()
       }
    
    func retryNowPlaying() {
        fetchNowPlaying()
    }
        
    func retryPopular() {
        fetchPopular()
    }
    
    func fetchInitialData() {
        print("fetchInitialData 호출됨")
        fetchNowPlaying()
        fetchPopular()
    }
}

