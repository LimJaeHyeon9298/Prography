//
//  TopRatedMovieUseCase.swift
//  Prography_assignment
//
//  Created by 임재현 on 2/20/25.
//

import Combine

protocol TopRatedMovieUseCaseImpl {
    func execute(page:Int) -> AnyPublisher<TopRatedMovieListDomain, NetworkError>
}

class TopRatedMovieUseCase: TopRatedMovieUseCaseImpl {
    private let repository: TopRatedMovieRepositoryProtocol
    
    init(repository: TopRatedMovieRepositoryProtocol) {
        self.repository = repository
    }
    
   
    
    func execute(page: Int) -> AnyPublisher<TopRatedMovieListDomain, NetworkError> {
        return repository.fetchTopRated(page: page)
            .mapError { $0 as NetworkError }
            .eraseToAnyPublisher()
    }
    
    
}
