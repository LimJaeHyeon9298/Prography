//
//  HomeCoordinator.swift
//  Prography_assignment
//
//  Created by 임재현 on 2/18/25.
//

import SwiftUI

class HomeCoordinator: CoordinatorProtocol,NavigationPopProtocol {
    typealias Route = HomeRoute
    
    @Published var navigationPath: NavigationPath = NavigationPath()
    private let container: DIContainer
    
    init(container: DIContainer) {
           self.container = container
       }
    
    func navigate(to route: HomeRoute) {
        switch route {
        case .detail(let movie):
            navigationPath.append(route)
        case .search:
            navigationPath.append(route)
        case .filter:
            navigationPath.append(route)
        }
    }
    
    @ViewBuilder
    func view(for route: HomeRoute) -> some View {
        switch route {
        case .detail(let movie):
            let viewModel = container.makeDetailViewModel(movieId: movie.id)
            DetailView(viewModel: viewModel, coordinator: self)
                           .navigationBarHidden(true)

        case .search:
            EmptyView()
        case .filter:
            EmptyView()
        }
    }
}
