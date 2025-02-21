//
//  MainCoordinator.swift
//  Prography_assignment
//
//  Created by 임재현 on 2/18/25.
//

import SwiftUI

class MainCoordinator: ObservableObject {
    let homeCoordinator: HomeCoordinator
    let myPageCoordinator: MyPageCoordinator
    
    init() {
        // MovieDetail 관련 의존성 설정
        let networkService = NetworkService()
        let accessToken = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJlOWFiZmM1ZjMyMTU5YTQ1OGNiY2FlNDU2MWJkZTI2MSIsIm5iZiI6MTcxNDM5MjM4Ny4wMDMsInN1YiI6IjY2MmY4ZDQyYzNhYTNmMDEyYmZkZDcyOSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.fQGM2SFY2wBbl_ebaJVWtJ4CVw-aDlHeVsmTF2NtC04"
        
        let movieDetailRepository = MovieDetailRepository(
            networkService: networkService,
            accessToken: accessToken
        )
        
        let movieDetailUseCase = MovieDetailUseCase(
            repository: movieDetailRepository
        )
        
        // Coordinator 초기화
        self.homeCoordinator = HomeCoordinator(detailUseCase: movieDetailUseCase)
        self.myPageCoordinator = MyPageCoordinator(detailUseCase: movieDetailUseCase)
    }
}
