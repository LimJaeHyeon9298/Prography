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
    @State private var selectedTab = 0
    private let tabs = ["인기 영화", "최신 개봉작", "추천 영화"]
    
    var body: some View {
        NavigationStack(path: $coordinator.navigationPath) {
            ScrollView {
                LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                    
                    CarouselView()
                        .padding(.top, 10)
                        .frame(height: 200)
                    
                    Section {
                        MovieSectionsContent(selectedTab: $selectedTab, tabs: tabs)
                            .frame(minHeight: UIScreen.main.bounds.height - 200)
                    } header: {
                        MovieSectionsHeader(selectedTab: $selectedTab, tabs: tabs)
                            .background(Color.white)

                            

                    }
                    .padding(.top,20)

                    

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

