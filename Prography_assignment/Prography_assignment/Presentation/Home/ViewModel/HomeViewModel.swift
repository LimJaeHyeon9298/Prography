//
//  HomeViewModel.swift
//  Prography_assignment
//
//  Created by 임재현 on 2/17/25.
//

import SwiftUI
import Combine


class HomeViewModel: ObservableObject {
    private let movieUseCase: NowPlayingUseCase

    // Now Playing Movies
    @Published private(set) var nowPlayingMovies: MovieListDomain?
    @Published private(set) var isLoadingNowPlaying = false
    @Published private(set) var nowPlayingError: NetworkError?
       
    // Popular Movies
    @Published private(set) var popularMovies: MovieListDomain?
    @Published private(set) var isLoadingPopular = false
    @Published private(set) var popularError: NetworkError?
       
    // Top Rated Movies
    @Published private(set) var topRatedMovies: MovieListDomain?
    @Published private(set) var isLoadingTopRated = false
      @Published private(set) var topRatedError: NetworkError?
    
    @Published var isLoadingMoreNowPlaying = false
    @Published var isLoadingMorePopular = false
        @Published var isLoadingMoreTopRated = false

    private let selectedMovieSubject = PassthroughSubject<MovieDomain, Never>()
    var selectedMoviePublisher: AnyPublisher<MovieDomain, Never> {
            selectedMovieSubject.eraseToAnyPublisher()
        }

    private var cancellables = Set<AnyCancellable>()
     var nowPlayingCurrentPage = 1
     var popularCurrentPage = 1
     var topRatedCurrentPage = 1
    

    init(movieUseCase: NowPlayingUseCase) {
        self.movieUseCase = movieUseCase
    }
    func fetchMovies(category: MovieCategory, page: Int) {
            switch category {
            case .nowPlaying:
                fetchNowPlaying(page: page)
            case .popular:
                fetchPopular(page: page)
            case .topRated:
                fetchTopRated(page: page)
            }
        }
    
    func selectMovie(_ movie: MovieDomain) {
            selectedMovieSubject.send(movie)
        }
    func setupNavigationSubscription(coordinator: HomeCoordinator) {
           selectedMoviePublisher
               .receive(on: DispatchQueue.main)
               .sink { movie in
                   coordinator.navigationPath.append(HomeRoute.detail(movie))
               }
               .store(in: &cancellables)
       }
    private func fetchNowPlaying(page: Int) {
        print("fetchNowPlaying 시작")
        isLoadingNowPlaying = true
        nowPlayingError = nil
        
        movieUseCase.execute(page: page, type: .nowPlaying)
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
                if page == 1 {
                    self?.nowPlayingMovies = movieList
                } else {
                    self?.nowPlayingMovies?.movies.append(contentsOf: movieList.movies)
                }
                self?.nowPlayingCurrentPage = page + 1
            }
            .store(in: &cancellables)
    }
    
    private func fetchPopular(page: Int) {
        print("fetchPopular 시작")
         isLoadingPopular = true
         popularError = nil
         
        movieUseCase.execute(page: page, type: .popular)
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
                 if page == 1 {
                     self?.popularMovies = movieList
                 } else {
                     self?.popularMovies?.movies.append(contentsOf: movieList.movies)
                 }
                 self?.popularCurrentPage = page + 1
             }
             .store(in: &cancellables)
     }
    
    private func fetchTopRated(page: Int) {
        movieUseCase.execute(page: page, type: .topRated)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.topRatedError = error
                    print("topRated error: \(error)")
                case .finished:
                    break
                }
            } receiveValue: { [weak self] movieList in
                if page == 1 {
                    self?.topRatedMovies = movieList
                } else {
                    self?.topRatedMovies?.movies.append(contentsOf: movieList.movies)
                }
                self?.topRatedCurrentPage = page + 1
            }
            .store(in: &cancellables)
    }
     

    func retryNowPlaying() {
    //    fetchNowPlaying()
    }
        
    func retryPopular() {
    //    fetchPopular()
    }
    
    func fetchInitialData() {
        print("fetchInitialData 호출됨")
        fetchNowPlaying(page: 1)
        fetchPopular(page: 1)
        fetchTopRated(page: 1)
    }
}

