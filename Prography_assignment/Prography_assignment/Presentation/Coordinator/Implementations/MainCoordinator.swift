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
    
    init(homeCoordinator: HomeCoordinator, myPageCoordinator: MyPageCoordinator) {
        self.homeCoordinator = homeCoordinator
        self.myPageCoordinator = myPageCoordinator
    }
}
