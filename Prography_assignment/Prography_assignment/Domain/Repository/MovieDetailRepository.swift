//
//  MovieDetailRepository.swift
//  Prography_assignment
//
//  Created by 임재현 on 2/21/25.
//

import Combine

protocol MovieDetailRepositoryProtocol {
    func fetchMovieDetail(movieId: Int) -> AnyPublisher<MovieDetailDomain, NetworkError>
}

struct MovieDetailRepository: MovieDetailRepositoryProtocol {
    private let networkService: NetworkServiceProtocol
    private let accessToken: String
    
    init(networkService: NetworkServiceProtocol, accessToken: String) {
        self.networkService = networkService
        self.accessToken = accessToken
    }
    
    func fetchMovieDetail(movieId: Int) -> AnyPublisher<MovieDetailDomain, NetworkError> {
            let parameters = CommonQueryParameters(
                language: "ko-KR",
                region: nil
            )
            
            return networkService.request(
                .details(movieID: movieId, parameters: parameters),
                accessToken: accessToken,
                environment: .development
            )
            .compactMap { (dto: MovieDetailDTO) -> MovieDetailDomain in
                MovieMapper.toDetailDomain(dto: dto)
            }
            .eraseToAnyPublisher()
        }
}
