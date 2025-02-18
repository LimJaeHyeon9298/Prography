//
//  CoordinatorProtocol.swift
//  Prography_assignment
//
//  Created by 임재현 on 2/18/25.
//

import SwiftUI

protocol CoordinatorProtocol: ObservableObject {
    associatedtype Route
    var navigationPath: NavigationPath { get set }
    func navigate(to route: Route)
}

extension CoordinatorProtocol {
    func popToRoot() {
        navigationPath.removeLast(navigationPath.count)
    }
    
    func popLast() {
        navigationPath.removeLast()
    }
}

