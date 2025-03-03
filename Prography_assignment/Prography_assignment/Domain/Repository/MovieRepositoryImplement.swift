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
    private let cacheManager = MovieCacheManager.shared
    
    init(networkService: NetworkServiceProtocol, accessToken: String) {
        self.networkService = networkService
        self.accessToken = accessToken
    }
    
    func fetchNowPlaying(page: Int) -> AnyPublisher<MovieListDomain, NetworkError> {
        
        if let cachedData = cacheManager.getMovie(type: .nowPlaying, page: page) {
            return Just(cachedData)
                .setFailureType(to: NetworkError.self)
                .eraseToAnyPublisher()
        }
        
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
            let domainModel = MovieMapper.toDomain(dto: dto, type: .nowPlaying)
            
            if let domainModel = domainModel {
                self.cacheManager.saveMovie(type: .nowPlaying, page: page, data: domainModel)
            }
            
            return domainModel
        }
        .eraseToAnyPublisher()
    }
    
    func fetchPopular(page: Int) -> AnyPublisher<MovieListDomain, NetworkError> {
        
        if let cachedData = cacheManager.getMovie(type: .popular, page: page) {
            return Just(cachedData)
                .setFailureType(to: NetworkError.self)
                .eraseToAnyPublisher()
        }
        
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
                let domainModel = MovieMapper.toDomain(dto: dto, type: .popular)
                
                if let domainModel = domainModel {
                    self.cacheManager.saveMovie(type: .popular, page: page, data: domainModel)
                }
                
                return domainModel
            }
            .eraseToAnyPublisher()
    }
    
    func fetchTopRated(page: Int) -> AnyPublisher<MovieListDomain, NetworkError> {
        
        if let cachedData = cacheManager.getMovie(type: .topRated, page: page) {
            return Just(cachedData)
                .setFailureType(to: NetworkError.self)
                .eraseToAnyPublisher()
        }
        
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
                let domainModel = MovieMapper.toDomain(dto: dto, type: .topRated)
                
                if let domainModel = domainModel {
                    self.cacheManager.saveMovie(type: .topRated, page: page, data: domainModel)
                }
                
                return domainModel
            }
            .eraseToAnyPublisher()
    }
    
    
}


