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
    @State private var selectedRating: Int? = nil
    
    let columns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]
    
    @State private var movies: [MovieItem] = (0..<10).map { index in
            MovieItem(
                title: "영화 제목 \(index)",
                rating: Double.random(in: 1...5).rounded(),
                imageUrl: "photo"
            )
        }
    
    var filteredMovies: [MovieItem] {
           guard let selectedRating = selectedRating else {
               return movies // "All" 선택시 모든 영화 표시
           }
           return movies.filter { Int($0.rating) == selectedRating }
       }
    
    var body: some View {
        NavigationStack(path: $coordinator.navigationPath) {
            ZStack(alignment: .top) {
                ScrollView {
                    VStack(spacing: 0) {
                        LazyVGrid(columns: columns, spacing: 10) {
                            ForEach(filteredMovies) { movie in
                                MovieGridItemView(movie: movie)
                            }
                        }
                        .padding(.horizontal, 10)
                        .padding(.top, 100)
                        .padding(.bottom, 150)
                    }
                }
                .ignoresSafeArea(.container, edges: .bottom)
                
                VStack {
                    DropdownView(selectedRating: $selectedRating)
                        .background(Color.white)
                        .zIndex(2)
                    Spacer()
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
