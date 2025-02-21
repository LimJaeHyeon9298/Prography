//
//  MyPageCoordinator.swift
//  Prography_assignment
//
//  Created by 임재현 on 2/18/25.
//

import SwiftUI

class MyPageCoordinator: CoordinatorProtocol,NavigationPopProtocol {
    typealias Route = MyPageRoute
    
    @Published var navigationPath: NavigationPath = NavigationPath()
    private let container: DIContainer
   
    
       
    init(container: DIContainer) {
            self.container = container
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
            let viewModel = container.makeDetailViewModel(movieId: movieId)
            DetailView(viewModel: viewModel, coordinator: self)
                           .navigationBarHidden(true)
        case .settings:
            EmptyView()
        case .profile:
            EmptyView()
        }
    }
    
    
}
