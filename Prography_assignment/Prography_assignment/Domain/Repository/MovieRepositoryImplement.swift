//
//  MovieRepository.swift
//  Prography_assignment
//
//  Created by 임재현 on 2/17/25.
//

import Combine

protocol MovieRepository {
    func fetchNowPlaying(page:Int) ->AnyPublisher<MovieListDomain, NetworkError>
    func fetchPopular(page: Int) -> AnyPublisher<MovieListDomain, NetworkError>
    func fetchTopRated(page: Int) -> AnyPublisher<MovieListDomain, NetworkError>
}


struct MovieRepositoryImplement: MovieRepository {
    
    private let networkService: NetworkServiceProtocol
    private let accessToken: String
    
    init(networkService: NetworkServiceProtocol, accessToken: String) {
        self.networkService = networkService
        self.accessToken = accessToken
    }
    
    func fetchNowPlaying(page: Int) -> AnyPublisher<MovieListDomain, NetworkError> {
        guard let validPage = Page(page) else {
            return Fail(error: NetworkError.invalidPage(page)).eraseToAnyPublisher()
        }
        
        let parameters = CommonQueryParameters(
            language: "ko-KR",
            region: nil
        )
        
        return networkService.request(
            .nowPlaying(page: validPage, parameters: parameters),
            accessToken: accessToken,
            environment: .development
        )
        .compactMap { (dto: MovieResponseDTO) -> MovieListDomain? in
            MovieMapper.toDomain(dto: dto, type: .nowPlaying)
        }
        .eraseToAnyPublisher()
    }
    
    func fetchPopular(page: Int) -> AnyPublisher<MovieListDomain, NetworkError> {
        guard let validPage = Page(page) else {
            return Fail(error: NetworkError.invalidPage(page)).eraseToAnyPublisher()
         }
         
         let parameters = CommonQueryParameters(
             language: "ko-KR",
             region: nil
         )
        
        return networkService.request(
            .popular(page: validPage, parameters: parameters),
                        accessToken: accessToken,
                        environment: .development
        
            )
            .compactMap { (dto: MovieResponseDTO) -> MovieListDomain? in
                MovieMapper.toDomain(dto: dto, type: .popular)
            }
            .eraseToAnyPublisher()
    }
    
    func fetchTopRated(page: Int) -> AnyPublisher<MovieListDomain, NetworkError> {
        guard let validPage = Page(page) else {
            return Fail(error: NetworkError.invalidPage(page)).eraseToAnyPublisher()
         }
         
         let parameters = CommonQueryParameters(
             language: "ko-KR",
             region: nil
         )
        
        return networkService.request(
            .topRated(page: validPage, parameters: parameters),
                        accessToken: accessToken,
                        environment: .development
        
            )
            .compactMap { (dto: MovieResponseDTO) -> MovieListDomain? in
                MovieMapper.toDomain(dto: dto, type: .topRated)
            }
            .eraseToAnyPublisher()
    }
    
    
}


