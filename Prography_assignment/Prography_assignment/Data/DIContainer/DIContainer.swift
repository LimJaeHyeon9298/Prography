//
//  DIContainer.swift
//  Prography_assignment
//
//  Created by 임재현 on 2/17/25.
//

import SwiftUI


final class DIContainer {
   // MARK: - Network Layer
   private let session: URLSession
   private let networkService: NetworkServiceProtocol
   
   // MARK: - Repository Layer
   private let movieRepository: MovieRepository
   private let movieDetailRepository: MovieDetailRepositoryProtocol
   
   // MARK: - UseCase Layer
   private let movieUseCase: NowPlayingUseCase
   private let movieDetailUseCase: MovieDetailUseCaseProtocol
   
   // MARK: - Coordinator Layer
   private var mainCoordinator: MainCoordinator?
    let reviewStore: ReviewStore
    
    
    
   // MARK: - Initialization
   init(session: URLSession = .shared) {
       // Network Layer
       self.session = session
       self.networkService = NetworkService(session: session)
       
       // Repository Layer
       let accessToken = Bundle.main.infoDictionary?["AccessToken"] as! String
       self.movieRepository = MovieRepositoryImplement(networkService: networkService, accessToken: accessToken)
       self.movieDetailRepository = MovieDetailRepository(networkService: networkService, accessToken: accessToken)
       
       // UseCase Layer
       self.movieUseCase = FetchNowPlayingMoviesUseCase(repository: movieRepository)
       self.movieDetailUseCase = MovieDetailUseCase(repository: movieDetailRepository)
       
       self.reviewStore = ReviewStore()
   }
   
   // MARK: - Factory Methods
   
   // ViewModel Factory
   func makeHomeViewModel() -> HomeViewModel {
       return HomeViewModel(movieUseCase: movieUseCase)
   }
   
   func makeDetailViewModel(movieId: Int) -> DetailViewModel {
       return DetailViewModel(
           movieId: movieId,
           detailUseCase: movieDetailUseCase, reviewStore: reviewStore
       )
   }
    
    func makeMyPageViewModel() -> MyPageViewModel {
        return MyPageViewModel(dataManager: DataManager.shared)
     }
   
   // Coordinator Factory
   func makeHomeCoordinator() -> HomeCoordinator {
       return HomeCoordinator(container: self)
   }
   
   func makeMyPageCoordinator() -> MyPageCoordinator {
       return MyPageCoordinator(container: self)
   }
   
   func makeMainCoordinator() -> MainCoordinator {
       if let existingCoordinator = mainCoordinator {
           return existingCoordinator
       }
       
       let homeCoordinator = makeHomeCoordinator()
       let myPageCoordinator = makeMyPageCoordinator()
       let coordinator = MainCoordinator(
           homeCoordinator: homeCoordinator,
           myPageCoordinator: myPageCoordinator
       )
       
       mainCoordinator = coordinator
       return coordinator
   }
}
