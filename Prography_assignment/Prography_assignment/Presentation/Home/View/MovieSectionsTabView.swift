//
//  MovieSectionsTabView.swift
//  Prography_assignment
//
//  Created by 임재현 on 2/19/25.
//

import SwiftUI

struct MovieSectionsTabView: View {
    @State private var selectedTab = 0
    private let tabs = ["인기 영화", "최신 개봉작", "추천 영화"]
    
    var body: some View {
        VStack(spacing: 0) {
            MovieSectionsHeader(selectedTab: $selectedTab, tabs: tabs)
            MovieSectionsContent(selectedTab: $selectedTab, tabs: tabs)
        }
    }
}

struct MovieSectionsHeader: View {
    @Binding var selectedTab: Int
    let tabs: [String]
    @Namespace private var namespace
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(tabs.enumerated()), id: \.element) { index, tab in
                VStack(spacing: 8) {
                    Text(tab)
                        .fontWeight(selectedTab == index ? .bold : .regular)
                        .foregroundColor(selectedTab == index ? .black : .gray)
                    
                    if selectedTab == index {
                        Rectangle()
                            .fill(.blue)
                            .frame(width: 70, height: 2)
                            .matchedGeometryEffect(id: "TAB_INDICATOR", in: namespace)
                    } else {
                        Rectangle()
                            .fill(.clear)
                            .frame(width: 40, height: 2)
                    }
                }
                .frame(maxWidth: .infinity)
                .onTapGesture {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedTab = index
                    }
                }
            }
        }
        .padding(.horizontal)
        .background(Color.white)
    }
}

struct MovieSectionsContent: View {
    @Binding var selectedTab: Int
    let tabs: [String]
    
    // 각 탭 인덱스에 맞는 영화 데이터를 반환하는 함수
    func moviesFor(index: Int) -> [Movie] {
        switch index {
        case 0: return MockData.popularMovies
        case 1: return MockData.newMovies
        case 2: return MockData.recommendedMovies
        default: return []
        }
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // 각 탭에 대해
            ForEach(0..<tabs.count, id: \.self) { index in
                // 해당 탭에 맞는 영화 데이터를 MovieSectionView에 전달
                MovieSectionView(movies: moviesFor(index: index))
                    .tag(index)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
    }
}





struct MovieSectionView: View {
    let movies: [Movie]
    
    func moviesFor(index: Int) -> [Movie] {
        switch index {
        case 0: return MockData.popularMovies
        case 1: return MockData.newMovies
        case 2: return MockData.recommendedMovies
        default: return []
        }
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(spacing: 16) {
                ForEach(movies) { movie in
                    MovieItemView(movie: movie)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal)
                }
            }
            .padding(.vertical)
            .padding(.bottom, 60)
     }
//        .scrollDisabled(false)  // 스크롤 활성화 유지
//                .simultaneousGesture(DragGesture().onChanged { value in
//                    // 스크롤이 최상단에 도달했을 때 상위 ScrollView로 전달
//                    if value.translation.height > 0 {  // 아래로 스크롤
//                        // 상위 스크롤 활성화
//                    }
//                })
            }
        }


struct MovieItemView: View {
    let movie: Movie
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .aspectRatio(2/3, contentMode: .fit)
                .frame(width: 100)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            
            VStack(alignment: .leading, spacing: 8) {
                Text("영화 제목")
                    .font(.pretendard(size: 22, family: .bold))
                    .lineLimit(1)
                    .foregroundStyle(.black)
                
                Text("OverView는 두줄이 넘지 않게 구현해 주세요")
                    .font(.pretendard(size: 16, family: .medium))
                    .lineLimit(2)
                    .foregroundStyle(.gray)
                
                Text("평점")
                    .font(.pretendard(size: 14, family: .semibold))
                    .lineLimit(1)
                    .foregroundStyle(.gray)
            }
            Spacer()
        }
        .padding(.vertical, 8)
    }
}

