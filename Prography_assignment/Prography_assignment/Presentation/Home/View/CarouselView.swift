//
//  CarouselView.swift
//  Prography_assignment
//
//  Created by 임재현 on 2/18/25.
//

import SwiftUI


struct CarouselView: View {
    @ObservedObject var viewModel: HomeViewModel
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 25) {
                if let movies = viewModel.nowPlayingMovies?.movies {
                    ForEach(movies.indices, id: \.self) { index in
                        MovieCard(movie: movies[index], viewModel:viewModel)
                            .shadow(radius: 5, x: 5, y: 5)
                            .scrollTransition { content, phase in
                                content
                                    .opacity(phase.isIdentity ? 1 : 0.5)
                                    .scaleEffect(y: phase.isIdentity ? 1 : 0.7)
                            }
                    }
                }
            }
            .scrollTargetLayout()
        }
        .contentMargins(50, for: .scrollContent)
        .scrollTargetBehavior(.viewAligned)
    }
}

struct MovieCard: View {
    let movie: MovieDomain
    let viewModel: HomeViewModel
    let recWidth: CGFloat = UIScreen.main.bounds.width - 100
    let recHeight: CGFloat = 200
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {  // alignment 변경
            // 배경 이미지
            AsyncImage(url: movie.posterURL) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: recWidth, height: recHeight)
            } placeholder: {
                ZStack {
                    Color.gray.opacity(0.3)
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(0.7)  
                }
            }
            
            LinearGradient(
                colors: [.black.opacity(0.7), .clear],
                startPoint: .bottom,
                endPoint: .center
            )
            
 
            VStack(alignment: .leading, spacing: 4) {
                Text(movie.title)
                    .font(.pretendard(size: 15, family: .bold))
                    .foregroundColor(.white)
                
               
                Text(movie.overview)
                    .lineLimit(1)
                    .font(.pretendard(size: 13, family: .bold))
                    .foregroundColor(.white)
                    .frame(width: recWidth * 0.7, alignment: .leading)
                
            }
            .padding(15)
        }
        .frame(width: recWidth, height: recHeight)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(radius: 10)
        .onTapGesture {
            viewModel.selectMovie(movie)
        }
    }
}



struct Movie: Identifiable {
    let id: Int
    let title: String
    let overview: String
    let rating: Double
}

struct MockData {
    static let popularMovies = [
        Movie(id: 1, title: "인기영화 1", overview: "인기영화 1에 대한 설명입니다.", rating: 8.5),
        Movie(id: 2, title: "인기영화 2", overview: "인기영화 2에 대한 설명입니다.", rating: 9.0),
        Movie(id: 3, title: "인기영화 3", overview: "인기영화 3에 대한 설명입니다.", rating: 7.8)
    ]
    
    static let newMovies = [
        Movie(id: 4, title: "최신영화 1", overview: "최신영화 1에 대한 설명입니다.", rating: 8.1),
        Movie(id: 5, title: "최신영화 2", overview: "최신영화 2에 대한 설명입니다.", rating: 7.5),
        Movie(id: 6, title: "최신영화 3", overview: "최신영화 3에 대한 설명입니다.", rating: 8.9),
        Movie(id: 7, title: "최신영화 4", overview: "최신영화 4에 대한 설명입니다.", rating: 7.2)
    ]
    
    static let recommendedMovies = [
        Movie(id: 8, title: "추천영화 1", overview: "추천영화 1에 대한 설명입니다.", rating: 9.2),
        Movie(id: 9, title: "추천영화 2", overview: "추천영화 2에 대한 설명입니다.", rating: 8.7),
        Movie(id: 10, title: "추천영화 3", overview: "추천영화 3에 대한 설명입니다.", rating: 8.4),
        Movie(id: 11, title: "추천영화 4", overview: "추천영화 4에 대한 설명입니다.", rating: 7.9),
        Movie(id: 12, title: "추천영화 5", overview: "추천영화 5에 대한 설명입니다.", rating: 8.2),
        Movie(id: 13, title: "추천영화 4", overview: "추천영화 4에 대한 설명입니다.", rating: 7.9),
        Movie(id: 14, title: "추천영화 4", overview: "추천영화 4에 대한 설명입니다.", rating: 7.9),
        Movie(id: 15, title: "추천영화 4", overview: "추천영화 4에 대한 설명입니다.", rating: 7.9),
        Movie(id: 16, title: "추천영화 4", overview: "추천영화 4에 대한 설명입니다.", rating: 7.9),
        Movie(id: 17, title: "추천영화 4", overview: "추천영화 4에 대한 설명입니다.", rating: 7.9),
        Movie(id: 18, title: "추천영화 4", overview: "추천영화 4에 대한 설명입니다.", rating: 7.9)
    ]
}

