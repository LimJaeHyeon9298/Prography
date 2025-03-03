//
//  MovieSectionsTabView.swift
//  Prography_assignment
//
//  Created by 임재현 on 2/19/25.
//

import SwiftUI

struct MovieSectionsHeader: View {
    @Binding var selectedTab: Int
    let tabs: [String]
    @Namespace private var namespace
    @ObservedObject var viewModel: HomeViewModel
    
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
                    let oldTab = selectedTab
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedTab = index
                    }
                    
                    // 탭이 변경되었고, 해당 카테고리의 데이터가 없거나 로딩 중인 경우 첫 페이지 로드
                    if oldTab != index {
                        let category: MovieCategory = index == 0 ? .nowPlaying :
                                                    (index == 1 ? .popular : .topRated)
                        
                        let hasData = index == 0 ? viewModel.nowPlayingMovies != nil :
                                     (index == 1 ? viewModel.popularMovies != nil :
                                                  viewModel.topRatedMovies != nil)
                        
                        if !hasData {
                            viewModel.fetchMovies(category: category, page: 1)
                        }
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
    @ObservedObject var viewModel: HomeViewModel
    
    var moviesForCurrentTab: [MovieDomain] {
        switch selectedTab {
        case 0:
            return viewModel.nowPlayingMovies?.movies ?? []
        case 1:
            return viewModel.popularMovies?.movies ?? []
        case 2:
            return viewModel.topRatedMovies?.movies ?? []
        default:
            return []
        }
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(0..<tabs.count, id: \.self) { index in
                MovieSectionView(
                    movies: moviesForCurrentTab,
                    viewModel: viewModel
                )
                .tag(index)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
    }
}

struct MovieSectionView: View {
    let movies: [MovieDomain]
    @ObservedObject var viewModel: HomeViewModel
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(spacing: 16) {
                ForEach(movies, id: \.id) { movie in
                    MovieRowView(movie: movie, viewModel: viewModel)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal)
                }
            }
            .padding(.vertical)
            .padding(.bottom, 60)
        }
    }
}

struct MovieRowView: View {
    let movie: MovieDomain
    let viewModel: HomeViewModel
    
    var body: some View {
        Button(action: {
            viewModel.selectMovie(movie)
        }) {
            HStack(spacing: 16) {
                // Poster Image
//                AsyncImage(url: movie.posterURL) { image in
//                    image
//                        .resizable()
//                        .aspectRatio(contentMode: .fill)
//                } placeholder: {
//                    Rectangle()
//                        .fill(Color.gray.opacity(0.3))
//                        .overlay(
//                            ProgressView()
//                                .progressViewStyle(CircularProgressViewStyle())
//                        )
//                }
                
                
                CachedAsyncImage(
                     url: movie.posterURL,
                     targetSize: CGSize(width: 100, height: 150)
                 ) {
                     Rectangle()
                         .fill(Color.gray.opacity(0.3))
                         .overlay(
                             ProgressView()
                                 .progressViewStyle(CircularProgressViewStyle())
                         )
                 }
                .frame(width: 100, height: 150)
                .cornerRadius(8)
                
                // Movie Info
                VStack(alignment: .leading, spacing: 8) {
                    Text(movie.title)
                        .font(.pretendard(size: 18, family: .bold))
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                        .truncationMode(.tail)
                    
                    Text(movie.overview)
                        .font(.pretendard(size: 14, family: .regular))
                        .foregroundColor(.gray)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                        .truncationMode(.tail)
                    
                    HStack {
                        Text(String(format: "%.1f", movie.rating))
                            .font(.pretendard(size: 14, family: .medium))
                        
                        Spacer()
                    }
                    GenreSection(genres: movie.getGenreNames())
                }
                
          
            }
            .frame(maxWidth: .infinity, alignment: .leading)
           
        }
        .foregroundColor(.primary)
    }
}

private struct GenreSection: View {
    let genres: [String]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(genres, id: \.self) { genre in
                    Text(genre)
                        .font(.pretendard(size: 12, family: .medium))
                        .foregroundColor(.black)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(
                            Capsule()
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                }
            }
        }
    }
}
