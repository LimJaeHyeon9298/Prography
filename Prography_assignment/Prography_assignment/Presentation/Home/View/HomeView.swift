//
//  HomeView.swift
//  Prography_assignment
//
//  Created by 임재현 on 2/17/25.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var coordinator: HomeCoordinator
    @Binding var hideTabBar: Bool
    
    var body: some View {
        NavigationStack(path: $coordinator.navigationPath) {
            VStack {
                
                CarouselView()
                    .padding(.top, -40)
                
                Spacer()
                
                MovieSectionsTabView()
                    .padding(.top, -10)
                
                
                Button("Go to Detail") {
                    hideTabBar = true 
                    coordinator.navigate(to: .detail)
                }
            }
            .navigationDestination(for: HomeRoute.self) { route in
                coordinator.view(for: route)
            }
        }
        .onChange(of: coordinator.navigationPath.count) { count in
                    hideTabBar = count > 0
                }
    }
}

