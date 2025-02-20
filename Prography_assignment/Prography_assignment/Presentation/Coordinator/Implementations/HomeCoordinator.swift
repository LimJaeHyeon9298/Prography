//
//  HomeCoordinator.swift
//  Prography_assignment
//
//  Created by 임재현 on 2/18/25.
//

import SwiftUI

class HomeCoordinator: CoordinatorProtocol {
    typealias Route = HomeRoute
    
    @Published var navigationPath: NavigationPath = NavigationPath()
    
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
            DetailView(movie: movie)
        case .search:
            EmptyView()
        case .filter:
            EmptyView()
        }
    }
}
