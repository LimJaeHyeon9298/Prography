//
//  MyPageView.swift
//  Prography_assignment
//
//  Created by 임재현 on 2/17/25.
//

import SwiftUI

struct MyPageView: View {
    @ObservedObject var coordinator: MyPageCoordinator
    @Binding var hideTabBar: Bool
    
    var body: some View {
        NavigationStack(path: $coordinator.navigationPath) {
            VStack {
                Button("Go to Detail") {
                    hideTabBar = true
                    coordinator.navigate(to: .detail)
                }
            }
            .navigationDestination(for: MyPageRoute.self) { route in
                coordinator.view(for: route)
            }
        }
        .onChange(of: coordinator.navigationPath.count) { count in
                    hideTabBar = count > 0
                }
    }
}

