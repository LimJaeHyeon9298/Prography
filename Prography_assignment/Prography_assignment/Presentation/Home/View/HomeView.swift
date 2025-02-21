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
            self._viewModel = StateObject(wrappedValue: container.makeMainViewModel())

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
        switch category {
        case .nowPlaying:
            ForEach(viewModel.nowPlayingMovies?.movies ?? [], id: \.id) { movie in
                MovieRowView(movie: movie, viewModel: viewModel)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal)
            }
            .padding(.vertical)
        
        case .popular:
            ForEach(viewModel.popularMovies?.movies ?? [], id: \.id) { movie in
                MovieRowView(movie: movie, viewModel: viewModel)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal)
            }
            .padding(.vertical)
        
        case .topRated:
            ForEach(viewModel.topRatedMovies?.movies ?? [], id: \.id) { movie in
                MovieRowView(movie: movie, viewModel: viewModel)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal)
            }
            .padding(.vertical)
        }
    }
}
