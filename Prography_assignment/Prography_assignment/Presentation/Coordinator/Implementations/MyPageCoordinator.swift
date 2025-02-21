//
//  MyPageCoordinator.swift
//  Prography_assignment
//
//  Created by 임재현 on 2/18/25.
//

import SwiftUI

class MyPageCoordinator: CoordinatorProtocol {
    typealias Route = MyPageRoute
    
    @Published var navigationPath: NavigationPath = NavigationPath()
    
    private let detailUseCase: MovieDetailUseCaseProtocol
       
       init(detailUseCase: MovieDetailUseCaseProtocol) {
           self.detailUseCase = detailUseCase
       }
    
    func navigate(to route: MyPageRoute) {
        switch route {
        case .detail(let movieId):
            navigationPath.append(route)
        case .settings:
            navigationPath.append(route)
        case .profile:
            navigationPath.append(route)
        }
    }
    
    @ViewBuilder
    func view(for route:MyPageRoute) -> some View {
        switch route {
        case .detail(let movieId):
            let viewModel = DetailViewModel(movieId: movieId, useCase: detailUseCase)
                    DetailView(viewType: .fromMyPage(viewModel))
                        .toolbar(.hidden, for: .navigationBar)
        case .settings:
            EmptyView()
        case .profile:
            EmptyView()
        }
    }
    
    
}
