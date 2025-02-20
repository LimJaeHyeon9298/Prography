//
//  MovieRepository.swift
//  Prography_assignment
//
//  Created by 임재현 on 2/17/25.
//

import Combine

protocol MovieRepositoryProtocol {
    func fetchNowPlaying(page:Int) ->AnyPublisher<MovieListDomain, NetworkError>
}


struct MovieRepository: MovieRepositoryProtocol {
    private let networkService: NetworkServiceProtocol
    private let accessToken: String
    
    init(networkService: NetworkServiceProtocol, accessToken: String) {
        self.networkService = networkService
        self.accessToken = accessToken
    }
    
    func fetchNowPlaying(page: Int) -> AnyPublisher<MovieListDomain, NetworkError> {
        let requestDTO = MovieRequestDTO(page: page,
                                         language: "en-US",
                                         region: nil)
        
        
        return networkService.request(
                .nowPlaying(
                    page: requestDTO.page,
                    language: requestDTO.language,
                    region: requestDTO.region
                ),
                accessToken: accessToken
            )
            .compactMap { (dto: MovieResponseDTO) -> MovieListDomain? in
                MovieMapper.toDomain(dto: dto)
            }
            .eraseToAnyPublisher()
    }
    
    
}


