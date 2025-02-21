//
//  MainTabView.swift
//  Prography_assignment
//
//  Created by 임재현 on 2/18/25.
//

import SwiftUI

struct MainTabView: View {
    private let container: DIContainer
    @StateObject private var coordinator: MainCoordinator
    @State private var selectedTab: TabItem = .home
    @State private var hideTabBar: Bool = false
    
    init(container: DIContainer) {
        self.container = container
        _coordinator = StateObject(wrappedValue: container.makeMainCoordinator())
    }
    
    var body: some View {
        VStack(spacing: 0) {
            
            CustomNavigationBar()
                
            
            ZStack(alignment: .bottom) {
                switch selectedTab {
                case .home:
                    HomeView(coordinator: coordinator.homeCoordinator,
                             container: container,
                             hideTabBar: $hideTabBar)
                        .ignoresSafeArea()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                case .myPage:
                    MyPageView(coordinator: coordinator.myPageCoordinator, hideTabBar: $hideTabBar)
                        .ignoresSafeArea()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                
                if !hideTabBar {
                    CustomTabBar(selectedTab: $selectedTab)
                        .background(.red)
                        .ignoresSafeArea(.keyboard)
                        .safeAreaInset(edge: .bottom) {Color.clear.frame(height: 0)}
                }
                

            }
        }
       
    }
}
