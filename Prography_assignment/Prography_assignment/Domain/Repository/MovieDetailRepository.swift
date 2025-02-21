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
        let language = "ko-KR"
        
        return networkService.request(
            .details(movieID: movieId, language: language),
            accessToken: accessToken
        )
        .compactMap { (dto: MovieDetailDTO) -> MovieDetailDomain in  // 여기를 수정
            return MovieMapper.toDomain(dto: dto)  // optional 반환이 아니라면 return 명시
        }
        .eraseToAnyPublisher()
    }
}
