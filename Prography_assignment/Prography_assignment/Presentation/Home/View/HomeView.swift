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
            ScrollView {
                LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                    
                    CarouselView(viewModel: viewModel)
                        .padding(.top, 10)
                        .frame(height: 200)
                    
                    Section {
                        MovieSectionsContent(
                            selectedTab: $selectedTab,
                            tabs: tabs,
                            viewModel: viewModel
                        )
                        .frame(minHeight: UIScreen.main.bounds.height - 200)
                    } header: {
                        MovieSectionsHeader(selectedTab: $selectedTab, tabs: tabs)
                            .background(Color.white)

                            

                    }
                    .padding(.top,20)
                }
            }
            .navigationDestination(for: HomeRoute.self) { route in
                coordinator.view(for: route)
            }
//            .onAppear {
//                print("HomeView appeared")
//                viewModel.fetchInitialData()
//                viewModel.setupNavigationSubscription(coordinator: coordinator)
//                loadReviews()
//
//            }
//            .onChange(of: viewModel.nowPlayingMovies) { movies in
//                            if let movies = movies {
//                                print("영화 데이터 받아옴:")
//                                print("- 현재 페이지:", movies.currentPage)
//                                print("- 전체 페이지:", movies.totalPages)
//                                print("- 영화 개수:", movies.movies.count)
//                                if let firstMovie = movies.movies.first {
//                                    print("첫 번째 영화:")
//                                    print("- 제목:", firstMovie.title)
//                                    print("- 개봉일:", firstMovie.releaseDate)
//                                    print("- overview:", firstMovie.overview)
//                                    
//                                }
//                            }
//                        }
            
//            .onChange(of: viewModel.popularMovies) { movies in
//               if let movies = movies {
//                   print("인기 영화 데이터 받아옴:")
//                   print("- 현재 페이지:", movies.currentPage)
//                   print("- 전체 페이지:", movies.totalPages)
//                   print("- 영화 개수:", movies.movies.count)
//                   if let firstMovie = movies.movies.first {
//                       print("첫 번째 영화:")
//                       print("- 제목:", firstMovie.title)
//                       print("- 개봉일:", firstMovie.releaseDate)
//                       print("- overview:", firstMovie.overview)
//                   }
//               }
//            }
//            .onChange(of: viewModel.topRatedMovies) { movies in
//                if let movies = movies {
//                    print("====== Top Rated Movies Response ======")
//                    print("📄 Page: \(movies.page)")
//                    print("📚 Total Pages: \(movies.totalPages)")
//                    print("🎯 Total Results: \(movies.totalResults)")
//                    
//                    print("\n🎬 Movies Details:")
//                    movies.movies.forEach { movie in
//                        print("\n----- Movie Info -----")
//                        print("🎥 Title: \(movie.title)")
//                        print("📝 Original Title: \(movie.originalTitle)")
//                        print("🆔 ID: \(movie.id)")
//                        print("📖 Overview: \(movie.overview)")
//                        print("🖼 Poster Path: \(movie.posterPath ?? "No poster")")
//                        print("🌄 Backdrop Path: \(movie.backdropPath ?? "No backdrop")")
//                        print("📅 Release Date: \(movie.releaseDate)")
//                        print("⭐️ Vote Average: \(movie.voteAverage)")
//                        print("👥 Vote Count: \(movie.voteCount)")
//                        print("📈 Popularity: \(movie.popularity)")
//                        print("🏷 Genre IDs: \(movie.genreIds)")
//                        print("🌐 Original Language: \(movie.originalLanguage)")
//                        print("🔞 Adult: \(movie.adult)")
//                        print("🎥 Video: \(movie.video)")
//                    }
//                    print("\n====== End of Top Rated Movies ======")
//                }
//            }
        }
        .onAppear {
               print("HomeView appeared")
               viewModel.fetchInitialData()
               viewModel.setupNavigationSubscription(coordinator: coordinator)
            //   loadReviews()
           }
           .onChange(of: coordinator.navigationPath.count) { oldValue, newValue in
               hideTabBar = newValue > 0
           }
           .onChange(of: viewModel.nowPlayingMovies) { oldValue, newValue in
               if let movies = newValue {
                   print("영화 데이터 받아옴:")
                   print("- 현재 페이지:", movies.currentPage)
                   print("- 전체 페이지:", movies.totalPages)
                   print("- 영화 개수:", movies.movies.count)
                   if let firstMovie = movies.movies.first {
                       print("첫 번째 영화:")
                       print("- 제목:", firstMovie.title)
                       print("- 개봉일:", firstMovie.releaseDate)
                       print("- overview:", firstMovie.overview)
                   }
               }
           }
           .onChange(of: viewModel.popularMovies) { oldValue, newValue in
               if let movies = newValue {
                   print("인기 영화 데이터 받아옴:")
                   print("- 현재 페이지:", movies.currentPage)
                   print("- 전체 페이지:", movies.totalPages)
                   print("- 영화 개수:", movies.movies.count)
                   // ... 나머지 로깅 ...
               }
           }
           .onChange(of: viewModel.topRatedMovies) { oldValue, newValue in
               if let movies = newValue {
                   print("====== Top Rated Movies Response ======")
                   // ... 나머지 로깅 ...
               }
           }

    }
    
//    private func loadReviews() {
//          do {
//              reviews = try DataManager.shared.fetchReviews(for: 939243)
//              
//          } catch {
//              print("Error fetching reviews: \(error)")
//          }
//      }
}



//struct HomeView: View {
//    @State private var reviews: [MovieReview] = []
//    @ObservedObject var coordinator: HomeCoordinator
//    @Binding var hideTabBar: Bool
//    @State private var selectedTab = 0
//    @State private var scrollOffset: CGFloat = 0
//    let tabs = ["상영중", "인기", "높은 평점"]
//    
//    @StateObject private var viewModel: HomeViewModel
//    
//    init(coordinator: HomeCoordinator,container: DIContainer,hideTabBar: Binding<Bool>) {
//        self.coordinator = coordinator
//        self._hideTabBar = hideTabBar
//        self._viewModel = StateObject(wrappedValue: container.makeMainViewModel())
//    }
//    
//    var body: some View {
//        NavigationStack(path: $coordinator.navigationPath) {
//            ZStack(alignment: .top) {
//                // Main Content
//                ScrollView {
//                    VStack(spacing: 0) {
//                        GeometryReader { proxy in
//                            Color.clear.preference(
//                                key: ScrollOffsetPreferenceKey.self,
//                                value: proxy.frame(in: .named("scroll")).minY
//                            )
//                        }
//                        .frame(height: 0)
//                        
//                        CarouselView(viewModel: viewModel)
//                            .padding(.top, 10)
//                            .frame(height: 200)
//                        
//                        MovieSectionsContent(
//                            selectedTab: $selectedTab,
//                            tabs: tabs,
//                            viewModel: viewModel
//                        )
//                        .frame(minHeight: UIScreen.main.bounds.height - 200)
//                        .padding(.top, 50) // Header height
//                    }
//                }
//                .coordinateSpace(name: "scroll")
//                .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
//                    scrollOffset = value
//                }
//                
//                // Sticky Header
//                MovieSectionsHeader(selectedTab: $selectedTab, tabs: tabs)
//                    .background(Color.white)
//                    .offset(y: max(210, scrollOffset + 210))
//                    .zIndex(1)
//            }
//            .navigationDestination(for: HomeRoute.self) { route in
//                coordinator.view(for: route)
//            }
//            .onAppear {
//                print("HomeView appeared")
//                viewModel.fetchInitialData()
//                viewModel.setupNavigationSubscription(coordinator: coordinator)
//                loadReviews()
//
//            }
//            .onChange(of: viewModel.nowPlayingMovies) { movies in
//                            if let movies = movies {
//                                print("영화 데이터 받아옴:")
//                                print("- 현재 페이지:", movies.currentPage)
//                                print("- 전체 페이지:", movies.totalPages)
//                                print("- 영화 개수:", movies.movies.count)
//                                if let firstMovie = movies.movies.first {
//                                    print("첫 번째 영화:")
//                                    print("- 제목:", firstMovie.title)
//                                    print("- 개봉일:", firstMovie.releaseDate)
//                                    print("- overview:", firstMovie.overview)
//                                    
//                                }
//                            }
//                        }
//            
//            .onChange(of: viewModel.popularMovies) { movies in
//               if let movies = movies {
//                   print("인기 영화 데이터 받아옴:")
//                   print("- 현재 페이지:", movies.currentPage)
//                   print("- 전체 페이지:", movies.totalPages)
//                   print("- 영화 개수:", movies.movies.count)
//                   if let firstMovie = movies.movies.first {
//                       print("첫 번째 영화:")
//                       print("- 제목:", firstMovie.title)
//                       print("- 개봉일:", firstMovie.releaseDate)
//                       print("- overview:", firstMovie.overview)
//                   }
//               }
//            }
//            .onChange(of: viewModel.topRatedMovies) { movies in
//                if let movies = movies {
//                    print("====== Top Rated Movies Response ======")
//                    print("📄 Page: \(movies.page)")
//                    print("📚 Total Pages: \(movies.totalPages)")
//                    print("🎯 Total Results: \(movies.totalResults)")
//                    
//                    print("\n🎬 Movies Details:")
//                    movies.movies.forEach { movie in
//                        print("\n----- Movie Info -----")
//                        print("🎥 Title: \(movie.title)")
//                        print("📝 Original Title: \(movie.originalTitle)")
//                        print("🆔 ID: \(movie.id)")
//                        print("📖 Overview: \(movie.overview)")
//                        print("🖼 Poster Path: \(movie.posterPath ?? "No poster")")
//                        print("🌄 Backdrop Path: \(movie.backdropPath ?? "No backdrop")")
//                        print("📅 Release Date: \(movie.releaseDate)")
//                        print("⭐️ Vote Average: \(movie.voteAverage)")
//                        print("👥 Vote Count: \(movie.voteCount)")
//                        print("📈 Popularity: \(movie.popularity)")
//                        print("🏷 Genre IDs: \(movie.genreIds)")
//                        print("🌐 Original Language: \(movie.originalLanguage)")
//                        print("🔞 Adult: \(movie.adult)")
//                        print("🎥 Video: \(movie.video)")
//                    }
//                    print("\n====== End of Top Rated Movies ======")
//                }
//            }
//            // ... 나머지 onAppear, onChange 등은 동일
//        }
//        .onChange(of: coordinator.navigationPath.count) { count in
//                    hideTabBar = count > 0
//        }
//    }
//    private func loadReviews() {
//            do {
//                reviews = try DataManager.shared.fetchReviews(for: 939243)
//  
//            } catch {
//                print("Error fetching reviews: \(error)")
//            }
//        }
//}
//
//// Preference Key for tracking scroll offset
//struct ScrollOffsetPreferenceKey: PreferenceKey {
//    static var defaultValue: CGFloat = 0
//    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
//        value = nextValue()
//    }
//}




