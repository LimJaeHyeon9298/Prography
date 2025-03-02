//
//  HomeView.swift
//  Prography_assignment
//
//  Created by 임재현 on 2/17/25.
//

import SwiftUI
//

struct HomeView: View {
    
    @State private var reviews: [MovieReview] = []
    @ObservedObject var coordinator: HomeCoordinator
    @Binding var hideTabBar: Bool
    @State private var selectedTab = 0
    let tabs = ["상영중", "인기", "높은 평점"]
    
    @StateObject private var viewModel: HomeViewModel
        
        init(coordinator: HomeCoordinator,container: DIContainer, hideTabBar: Binding<Bool>) {
            self.coordinator = coordinator
            self._hideTabBar = hideTabBar
            self._viewModel = StateObject(wrappedValue: container.makeHomeViewModel())

        }
    
    
    var body: some View {
        NavigationStack(path: $coordinator.navigationPath) {
           
            VStack {
                LogoView()
                ScrollView {
                    LazyVStack(spacing: 20, pinnedViews: [.sectionHeaders]) {
                        // Top Content (Carousel)
                        CarouselView(viewModel: viewModel)
                            .padding(.top, 10)
                            .frame(height: 200)
                            .padding(.bottom, 30)
                        
                        // Section with Sticky Header and Content
                        Section(header:
                            MovieSectionsHeader(selectedTab: $selectedTab, tabs: tabs)
                                .background(Color.white)
                                
                        ) {
                            
                            MovieListSection(viewModel: viewModel, category: selectedTab == 0 ? .nowPlaying : (selectedTab == 1 ? .popular : .topRated))
                            
                        }
                        

                    }
                }
            }
            
           
            .padding(.bottom, 65)
            .navigationDestination(for: HomeRoute.self) { route in
                coordinator.view(for: route)
            }
        }
        .onAppear {
            viewModel.fetchInitialData()
            viewModel.setupNavigationSubscription(coordinator: coordinator)
        }
        .onChange(of: coordinator.navigationPath.count) { oldValue, newValue in
            hideTabBar = newValue > 0
        }
    }
}

struct NowPlayingMoviesSection: View {
    @ObservedObject var viewModel: HomeViewModel
    
    var body: some View {
        ForEach(viewModel.nowPlayingMovies?.movies ?? [], id: \.id) { movie in
            MovieRowView(movie: movie, viewModel: viewModel)
                .frame(maxWidth: .infinity)
                .padding(.horizontal)
        }
        .padding(.vertical)
    }
}

struct PopularMoviesSection: View {
    @ObservedObject var viewModel: HomeViewModel
    
    var body: some View {
        ForEach(viewModel.popularMovies?.movies ?? [], id: \.id) { movie in
            MovieRowView(movie: movie, viewModel: viewModel)
                .frame(maxWidth: .infinity)
                .padding(.horizontal)
        }
        .padding(.vertical)
    }
}

struct TopRatedMoviesSection: View {
    @ObservedObject var viewModel: HomeViewModel
    
    var body: some View {
        ForEach(viewModel.topRatedMovies?.movies ?? [], id: \.id) { movie in
            MovieRowView(movie: movie, viewModel: viewModel)
                .frame(maxWidth: .infinity)
                .padding(.horizontal)
        }
        .padding(.vertical)
    }
}


enum MovieCategory {
    case nowPlaying
    case popular
    case topRated
}


struct MovieListSection: View {
    @ObservedObject var viewModel: HomeViewModel
    let category: MovieCategory
    
    var body: some View {
        LazyVStack(spacing: 16) {
            if let movies = moviesForCategory(), !movies.isEmpty {
                ForEach(Array(zip(movies.indices, movies)), id: \.0) { index, movie in
                    MovieRowView(movie: movie, viewModel: viewModel)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal)
                        .id("\(category)-\(movie.id)-\(index)")
                    
                    // 마지막 아이템에 도달했을 때 다음 페이지 로드
                    if index == movies.count - 3 && !isLoadingMoreForCategory() {
                        ProgressView()
                            .onAppear {
                                loadNextPage()
                            }
                    }
                }
            } else if isLoadingForCategory() {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .padding()
            } else if errorForCategory() != nil {
                VStack {
                    Text("데이터를 불러올 수 없습니다.")
                    Button("다시 시도") {
                        retryForCategory()
                    }
                    .buttonStyle(.bordered)
                }
                .padding()
            } else {
                Text("영화가 없습니다.")
                    .frame(maxWidth: .infinity)
                    .padding()
            }
        }
        .padding(.vertical)
    }
    
    // 카테고리별 영화 데이터 가져오기
    private func moviesForCategory() -> [MovieDomain]? {
        switch category {
        case .nowPlaying:
            return viewModel.nowPlayingMovies?.movies
        case .popular:
            return viewModel.popularMovies?.movies
        case .topRated:
            return viewModel.topRatedMovies?.movies
        }
    }
    
    // 카테고리별 로딩 상태 확인
    private func isLoadingForCategory() -> Bool {
        switch category {
        case .nowPlaying:
            return viewModel.isLoadingNowPlaying
        case .popular:
            return viewModel.isLoadingPopular
        case .topRated:
            return viewModel.isLoadingTopRated
        }
    }
    
    // 카테고리별 추가 로딩 상태 확인
    private func isLoadingMoreForCategory() -> Bool {
        switch category {
        case .nowPlaying:
            return viewModel.isLoadingMoreNowPlaying
        case .popular:
            return viewModel.isLoadingMorePopular
        case .topRated:
            return viewModel.isLoadingMoreTopRated
        }
    }
    
    // 카테고리별 에러 확인
    private func errorForCategory() -> NetworkError? {
        switch category {
        case .nowPlaying:
            return viewModel.nowPlayingError
        case .popular:
            return viewModel.popularError
        case .topRated:
            return viewModel.topRatedError
        }
    }
    
    // 다시 시도 기능
    private func retryForCategory() {
        viewModel.fetchMovies(category: category, page: 1)
    }
    
    // 다음 페이지 로드
    private func loadNextPage() {
        switch category {
        case .nowPlaying:
            viewModel.fetchMovies(category: .nowPlaying, page: viewModel.nowPlayingCurrentPage)
        case .popular:
            viewModel.fetchMovies(category: .popular, page: viewModel.popularCurrentPage)
        case .topRated:
            viewModel.fetchMovies(category: .topRated, page: viewModel.topRatedCurrentPage)
        }
    }
}
