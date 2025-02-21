//
//  MyPageView.swift
//  Prography_assignment
//
//  Created by 임재현 on 2/17/25.
//

import SwiftUI
import SwiftData

struct MyPageView: View {
   @ObservedObject var coordinator: MyPageCoordinator
   @StateObject private var viewModel: MyPageViewModel
   @Binding var hideTabBar: Bool
   @State private var selectedRating: Int? = nil
   
   let columns = [
       GridItem(.flexible(), spacing: 10),
       GridItem(.flexible(), spacing: 10),
       GridItem(.flexible(), spacing: 10)
   ]
   
   var filteredReviews: [MovieReview] {
       guard let selectedRating = selectedRating else {
           return viewModel.reviews
       }
       return viewModel.reviews.filter { Int($0.rating) == selectedRating }
   }
   
   init(
       coordinator: MyPageCoordinator,
       viewModel: MyPageViewModel? = nil,
       hideTabBar: Binding<Bool>
   ) {
       self.coordinator = coordinator
       _hideTabBar = hideTabBar
       
       // 뷰 모델이 전달되지 않았다면 새로 생성
       _viewModel = StateObject(wrappedValue: viewModel ?? MyPageViewModel(dataManager: DataManager.shared))
   }
   
   var body: some View {
       NavigationStack(path: $coordinator.navigationPath) {
           VStack {
               LogoView()
               ZStack(alignment: .top) {
                   ScrollView {
                       VStack(spacing: 0) {
                           LazyVGrid(columns: columns, spacing: 10) {
                               ForEach(filteredReviews) { review in
                                   MovieGridItemView(movie: review, onTapItem: { movieId in
                                       coordinator.navigate(to: .detail(movieId: movieId))
                                   })
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
           }
           .navigationDestination(for: MyPageRoute.self) { route in
               coordinator.view(for: route)
           }
       }
       .onAppear {
           viewModel.fetchReviews()
       }
       .onChange(of: coordinator.navigationPath.count) { count in
           hideTabBar = count > 0
           if count == 0 {  // 뒤로 갔을 때
                           viewModel.fetchReviews()
                       }
       }


   }
}
