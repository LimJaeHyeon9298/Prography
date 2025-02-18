//
//  FetchNowPlayingMoviesUseCase.swift
//  Prography_assignment
//
//  Created by 임재현 on 2/18/25.
//

import Combine

protocol NowPlayingUseCaseImpl {
    func execute(page:Int) -> AnyPublisher<MovieListDomain, NetworkError>
}

class FetchNowPlayingMoviesUseCase: NowPlayingUseCaseImpl {
    
    init(repository: MovieRepository) {
        self.repository = repository
    }
    
    private let repository: MovieRepository
    
    func execute(page: Int) -> AnyPublisher<MovieListDomain, NetworkError> {
        return repository.fetchNowPlaying(page: page)
            .mapError { $0 as NetworkError }
            .eraseToAnyPublisher()
    }
    
    
}
