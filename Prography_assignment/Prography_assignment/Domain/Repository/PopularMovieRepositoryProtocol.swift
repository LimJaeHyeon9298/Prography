//
//  PopularMovieRepositoryProtocol.swift
//  Prography_assignment
//
//  Created by 임재현 on 2/19/25.
//

import Combine

//protocol PopularMovieRepositoryProtocol {
//    func fetchPopular(page: Int) -> AnyPublisher<PopularMovieListDomain, NetworkError>
//}
//
//struct PopularMovieRepository: PopularMovieRepositoryProtocol {
//    private let networkService: NetworkServiceProtocol
//    private let accessToken: String
//    
//    init(networkService: NetworkServiceProtocol, accessToken: String) {
//        self.networkService = networkService
//        self.accessToken = accessToken
//    }
//    
//    func fetchPopular(page: Int) -> AnyPublisher<PopularMovieListDomain, NetworkError> {
//        let requestDTO = MovieRequestDTO(page: page,
//                                     language: "en-US",
//                                     region: nil)
//        
//        return networkService.request(
//            .popular(
//                page: requestDTO.page,
//                language: requestDTO.language,
//                region: requestDTO.region
//            ),
//            accessToken: accessToken
//        )
//        .compactMap { (dto: PopularMovieResponseDTO) -> PopularMovieListDomain? in
//            MovieMapper.toDomain(dto: dto)
//        }
//        .eraseToAnyPublisher()
//    }
//}
