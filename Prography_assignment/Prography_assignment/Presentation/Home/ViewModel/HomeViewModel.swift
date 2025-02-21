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
    


    private let selectedMovieSubject = PassthroughSubject<MovieDomain, Never>()
    var selectedMoviePublisher: AnyPublisher<MovieDomain, Never> {
            selectedMovieSubject.eraseToAnyPublisher()
        }

    private var cancellables = Set<AnyCancellable>()
    private var nowPlayingCurrentPage = 1
    private var popularCurrentPage = 1
    private var topRatedCurrentPage = 1
    

    init(movieUseCase: NowPlayingUseCase) {
        self.movieUseCase = movieUseCase
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
    func fetchNowPlaying() {
        print("fetchNowPlaying 시작")
        isLoadingNowPlaying = true
        nowPlayingError = nil
        
        movieUseCase.execute(page: nowPlayingCurrentPage, type: .nowPlaying)
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
         
        movieUseCase.execute(page: popularCurrentPage, type: .popular)
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
    
    func fetchTopRated() {
        movieUseCase.execute(page:topRatedCurrentPage,type: .topRated)
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
                self?.topRatedMovies = movieList
                self?.topRatedCurrentPage += 1
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
       
//    func loadMoreNowPlayingIfNeeded(currentItem movie: MovieDomain) {
//        guard let movies = nowPlayingMovies,
//              !isLoadingNowPlaying,
//              nowPlayingCurrentPage <= movies.totalPages,
//              movies.movies.last?.id == movie.id else {
//            return
//        }
//        
//        fetchNowPlaying()
//    }
    
    func retryNowPlaying() {
    //    fetchNowPlaying()
    }
        
    func retryPopular() {
    //    fetchPopular()
    }
    
    func fetchInitialData() {
        print("fetchInitialData 호출됨")
        fetchNowPlaying()
        fetchPopular()
        fetchTopRated()
    }
}

