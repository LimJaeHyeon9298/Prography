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
    
    private var hasCheckedCache = false

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
        if page == 1 {
            isLoadingNowPlaying = true
        } else {
            isLoadingMoreNowPlaying = true
        }
        nowPlayingError = nil
        
        movieUseCase.execute(page: page, type: .nowPlaying)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if page == 1 {
                    self?.isLoadingNowPlaying = false
                } else {
                    self?.isLoadingMoreNowPlaying = false
                }
                
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
                    // 기존 영화 목록에 새 데이터 추가
                    self?.nowPlayingMovies?.movies.append(contentsOf: movieList.movies)
                }
                
                // 다음 페이지가 있는지 확인 (총 페이지 수 체크)
                if page < movieList.totalPages {
                    self?.nowPlayingCurrentPage = page + 1
                }
            }
            .store(in: &cancellables)
    }
    
    private func fetchPopular(page: Int) {
        if page == 1 {
            isLoadingPopular = true
        } else {
            isLoadingMorePopular = true
        }
        popularError = nil
        
        movieUseCase.execute(page: page, type: .popular)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if page == 1 {
                    self?.isLoadingPopular = false
                } else {
                    self?.isLoadingMorePopular = false
                }
                
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
                    // 기존 영화 목록에 새 데이터 추가
                    self?.popularMovies?.movies.append(contentsOf: movieList.movies)
                }
                
                // 다음 페이지가 있는지 확인
                if page < movieList.totalPages {
                    self?.popularCurrentPage = page + 1
                }
            }
            .store(in: &cancellables)
    }
    
    private func fetchTopRated(page: Int) {
        if page == 1 {
            isLoadingTopRated = true
        } else {
            isLoadingMoreTopRated = true
        }
        topRatedError = nil
        
        movieUseCase.execute(page: page, type: .topRated)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if page == 1 {
                    self?.isLoadingTopRated = false
                } else {
                    self?.isLoadingMoreTopRated = false
                }
                
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
                    // 기존 영화 목록에 새 데이터 추가
                    self?.topRatedMovies?.movies.append(contentsOf: movieList.movies)
                }
                
                // 다음 페이지가 있는지 확인
                if page < movieList.totalPages {
                    self?.topRatedCurrentPage = page + 1
                }
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
        
        hasCheckedCache = true
    }
    
    func refreshIfNeeded() {
        guard hasCheckedCache else { return }
        
        // 마지막 데이터 업데이트 시간 확인
        let currentTime = Date()
        let cacheRefreshInterval: TimeInterval = 30 * 60 // 30분마다 새로고침
        
        // UserDefaults나 앱 내부 저장소에서 마지막 업데이트 시간 가져오기
        let lastUpdateTime = UserDefaults.standard.object(forKey: "lastMovieDataUpdateTime") as? Date ?? Date(timeIntervalSince1970: 0)
        
        // 마지막 업데이트 후 지정된 시간이 지났는지 확인
        if currentTime.timeIntervalSince(lastUpdateTime) > cacheRefreshInterval {
            // 데이터를 백그라운드에서 새로고침
            fetchInitialData()
            
            // 업데이트 시간 저장
            UserDefaults.standard.set(currentTime, forKey: "lastMovieDataUpdateTime")
        }
    }
}

