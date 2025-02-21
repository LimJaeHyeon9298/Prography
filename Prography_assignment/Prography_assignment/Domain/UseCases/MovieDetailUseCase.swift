//
//  MovieDetailUseCase.swift
//  Prography_assignment
//
//  Created by 임재현 on 2/21/25.
//

import Combine

protocol MovieDetailUseCaseProtocol {
   func execute(movieId: Int) -> AnyPublisher<MovieDetailDomain, NetworkError>
}

class MovieDetailUseCase: MovieDetailUseCaseProtocol {
   private let repository: MovieDetailRepositoryProtocol
   
   init(repository: MovieDetailRepositoryProtocol) {
       self.repository = repository
   }
   
   func execute(movieId: Int) -> AnyPublisher<MovieDetailDomain, NetworkError> {
       return repository.fetchMovieDetail(movieId: movieId)
           .mapError { $0 as NetworkError }
           .eraseToAnyPublisher()
   }
}
