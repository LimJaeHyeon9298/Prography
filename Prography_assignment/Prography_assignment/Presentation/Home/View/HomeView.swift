//
//  HomeView.swift
//  Prography_assignment
//
//  Created by 임재현 on 2/17/25.
//

import SwiftUI
//
//struct HomeView: View {
//    @State private var reviews: [MovieReview] = []
//    @ObservedObject var coordinator: HomeCoordinator
//    @Binding var hideTabBar: Bool
//    @State private var selectedTab = 0
//    let tabs = ["상영중", "인기", "높은 평점"]
//    
//    @StateObject private var viewModel: HomeViewModel
//        
//        init(coordinator: HomeCoordinator,container: DIContainer, hideTabBar: Binding<Bool>) {
//            self.coordinator = coordinator
//            self._hideTabBar = hideTabBar
//            self._viewModel = StateObject(wrappedValue: container.makeMainViewModel())
//
//        }
//    
//    var body: some View {
//        NavigationStack(path: $coordinator.navigationPath) {
//            ScrollView {
//                LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
//                    
//                    CarouselView(viewModel: viewModel)
//                        .padding(.top, 10)
//                        .frame(height: 200)
//                    
//                    Section {
//                        MovieSectionsContent(
//                            selectedTab: $selectedTab,
//                            tabs: tabs,
//                            viewModel: viewModel
//                        )
//                        .frame(minHeight: UIScreen.main.bounds.height - 200)
//                    } header: {
//                        MovieSectionsHeader(selectedTab: $selectedTab, tabs: tabs)
//                            .background(Color.white)
//
//                    }
//                    .padding(.top,20)
//                }
//            }
//            .navigationDestination(for: HomeRoute.self) { route in
//                coordinator.view(for: route)
//            }
//        }
//        .onAppear {
//               print("HomeView appeared")
//               viewModel.fetchInitialData()
//               viewModel.setupNavigationSubscription(coordinator: coordinator)
//            //   loadReviews()
//           }
//           .onChange(of: coordinator.navigationPath.count) { oldValue, newValue in
//               hideTabBar = newValue > 0
//           }
//    }
//}


struct HomeView: View {
    
    @State private var reviews: [MovieReview] = []
    @ObservedObject var coordinator: HomeCoordinator
    @Binding var hideTabBar: Bool
    @State private var selectedTab = 0
    let tabs = ["상영중", "인기", "높은 평점"]
    
    @StateObject private var viewModel: HomeViewModel
        
        init(coordinator: HomeCoordinator,container: DIContainer, hideTabBar: Binding<Bool>) {
            self.coordinator = coordinator
            self._hideTabBar = hideTabBar
            self._viewModel = StateObject(wrappedValue: container.makeMainViewModel())

        }
    
    
    var body: some View {
        NavigationStack(path: $coordinator.navigationPath) {
            ScrollView {
                LazyVStack(spacing: 20, pinnedViews: [.sectionHeaders]) {
                    // Top Content (Carousel)
                    CarouselView(viewModel: viewModel)
                        .padding(.top, 10)
                        .frame(height: 200)
                    
                    // Section with Sticky Header and Content
                    Section(header:
                        MovieSectionsHeader(selectedTab: $selectedTab, tabs: tabs)
                            .background(Color.white)
                    ) {
                        ForEach(viewModel.nowPlayingMovies?.movies ?? [], id: \.id) { movie in
                            MovieRowView(movie: movie, viewModel: viewModel)
                                .frame(maxWidth: .infinity)
                                .padding(.horizontal)
                        }
                        .padding(.vertical)
                        
                    }

                }
            }
            .padding(.bottom, 65)
            .navigationDestination(for: HomeRoute.self) { route in
                coordinator.view(for: route)
            }
        }
        .onAppear {
            viewModel.fetchInitialData()
            viewModel.setupNavigationSubscription(coordinator: coordinator)
        }
        .onChange(of: coordinator.navigationPath.count) { oldValue, newValue in
            hideTabBar = newValue > 0
        }
    }
}
