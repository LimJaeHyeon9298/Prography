//
//  HomeView.swift
//  Prography_assignment
//
//  Created by 임재현 on 2/17/25.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var coordinator: HomeCoordinator
    @Binding var hideTabBar: Bool
    
    @StateObject private var viewModel: HomeViewModel
        
        init(coordinator: HomeCoordinator, hideTabBar: Binding<Bool>) {
            self.coordinator = coordinator
            self._hideTabBar = hideTabBar
            
            // 테스트를 위한 임시 초기화
            let accessToken = Bundle.main.infoDictionary?["AccessToken"] as! String
            let networkService = NetworkService()
            let repository = MovieRepository(networkService: networkService, accessToken: accessToken )
            let repository2 = PopularMovieRepository(networkService: networkService, accessToken: accessToken )
            let useCase = FetchNowPlayingMoviesUseCase(repository: repository)
            let useCase2 = PopularMovieUseCase(repository: repository2)
            let repository3 = TopRateMovieRepository(networkService: networkService,accessToken: accessToken)
            let useCase3 = TopRatedMovieUseCase(repository: repository3)
            self._viewModel = StateObject(wrappedValue: HomeViewModel(nowPlayingUseCase: useCase, popularUseCase: useCase2, topRatedUseCase: useCase3))
        }
    
    
    var body: some View {
        NavigationStack(path: $coordinator.navigationPath) {
            VStack {
                Button("Go to Detail") {
                    hideTabBar = true 
                    coordinator.navigate(to: .detail)
                }
            }
            .navigationDestination(for: HomeRoute.self) { route in
                coordinator.view(for: route)
            }
            
            .onAppear {
                print("HomeView appeared")
                viewModel.fetchInitialData()
            }
//            .onChange(of: viewModel.isLoading) { isLoading in
//                print("로딩 상태 변경:", isLoading)
//            }
            .onChange(of: viewModel.nowPlayingMovies) { movies in
                            if let movies = movies {
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
            
            .onChange(of: viewModel.popularMovies) { movies in
               if let movies = movies {
                   print("인기 영화 데이터 받아옴:")
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
            .onChange(of: viewModel.topRatedMovies) { movies in
                if let movies = movies {
                    print("====== Top Rated Movies Response ======")
                    print("📄 Page: \(movies.page)")
                    print("📚 Total Pages: \(movies.totalPages)")
                    print("🎯 Total Results: \(movies.totalResults)")
                    
                    print("\n🎬 Movies Details:")
                    movies.movies.forEach { movie in
                        print("\n----- Movie Info -----")
                        print("🎥 Title: \(movie.title)")
                        print("📝 Original Title: \(movie.originalTitle)")
                        print("🆔 ID: \(movie.id)")
                        print("📖 Overview: \(movie.overview)")
                        print("🖼 Poster Path: \(movie.posterPath ?? "No poster")")
                        print("🌄 Backdrop Path: \(movie.backdropPath ?? "No backdrop")")
                        print("📅 Release Date: \(movie.releaseDate)")
                        print("⭐️ Vote Average: \(movie.voteAverage)")
                        print("👥 Vote Count: \(movie.voteCount)")
                        print("📈 Popularity: \(movie.popularity)")
                        print("🏷 Genre IDs: \(movie.genreIds)")
                        print("🌐 Original Language: \(movie.originalLanguage)")
                        print("🔞 Adult: \(movie.adult)")
                        print("🎥 Video: \(movie.video)")
                    }
                    print("\n====== End of Top Rated Movies ======")
                }
            }
            
//            .onChange(of: viewModel.topRatedMovies) { movies in
//               if let movies = movies {
//                   
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
            
        }
        .onChange(of: coordinator.navigationPath.count) { count in
                    hideTabBar = count > 0
                }
        

    }
}

