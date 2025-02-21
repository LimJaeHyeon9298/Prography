//
//  TopRateMovieRepository.swift
//  Prography_assignment
//
//  Created by 임재현 on 2/20/25.
//

import Combine

//protocol TopRatedMovieRepositoryProtocol {
//    func fetchTopRated(page: Int) -> AnyPublisher<TopRatedMovieListDomain, NetworkError>
//}
//
//struct TopRateMovieRepository: TopRatedMovieRepositoryProtocol {
//    private let networkService: NetworkServiceProtocol
//    private let accessToken: String
//    
//    init(networkService: NetworkServiceProtocol, accessToken: String) {
//        self.networkService = networkService
//        self.accessToken = accessToken
//    }
//    
//    func fetchTopRated(page: Int) -> AnyPublisher<TopRatedMovieListDomain, NetworkError> {
//        let requestDTO = MovieRequestDTO(page: page,
//                                     language: "en-US",
//                                     region: nil)
//        
//        return networkService.request(
//                 .topRated(page: page,
//                  language: requestDTO.language,
//                  region: requestDTO.region
//                ),
//                accessToken: accessToken)
//        .compactMap { (dto: TopRatedMovieResponseDTO) -> TopRatedMovieListDomain? in
//            MovieMapper.toDomain(dto: dto)
//        }
//        .eraseToAnyPublisher()
//        
//    }
//    
//    
//}
