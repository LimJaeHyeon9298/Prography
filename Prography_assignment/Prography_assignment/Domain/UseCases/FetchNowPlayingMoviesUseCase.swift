//
//  FetchNowPlayingMoviesUseCase.swift
//  Prography_assignment
//
//  Created by 임재현 on 2/18/25.
//

import Combine

    enum MovieListType {
        case nowPlaying
        case popular
        case topRated
    }

    protocol NowPlayingUseCase {
        func execute(page: Int, type: MovieListType) -> AnyPublisher<MovieListDomain, NetworkError>
    }

    class FetchNowPlayingMoviesUseCase: NowPlayingUseCase {
        private let repository: MovieRepository
        init(repository: MovieRepository) {
            self.repository = repository
        }

        func execute(page: Int, type: MovieListType) -> AnyPublisher<MovieListDomain, NetworkError> {
            switch type {
            case .nowPlaying:
                return repository.fetchNowPlaying(page: page)
                    .mapError { $0 as NetworkError }
                    .eraseToAnyPublisher()
            case .popular:
                return repository.fetchPopular(page: page)
                    .mapError { $0 as NetworkError }
                    .eraseToAnyPublisher()
            case .topRated:
                return repository.fetchTopRated(page: page)
                    .mapError { $0 as NetworkError }
                    .eraseToAnyPublisher()
            }
        }

    }
