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
    
    func navigate(to route: MyPageRoute) {
        switch route {
        case .detail:
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
        case .detail:
            DetailView()
        case .settings:
            DetailView()
        case .profile:
            DetailView()
        }
    }
    
    
}
