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
                if let movies = viewModel.nowPlayingMovies?.movies, !movies.isEmpty {
                    ForEach(movies.indices, id: \.self) { index in
                        MovieCard(movie: movies[index], viewModel: viewModel)
                            .shadow(radius: 5, x: 5, y: 5)
                            .scrollTransition { content, phase in
                                content
                                    .opacity(phase.isIdentity ? 1 : 0.5)
                                    .scaleEffect(y: phase.isIdentity ? 1 : 0.7)
                            }
                    }
                } else {
                    // Placeholder cards when no movies are available
                    ForEach(0..<3, id: \.self) { _ in
                        PlaceholderMovieCard()
                            .shadow(radius: 5, x: 5, y: 5)
                    }
                }
            }
            .scrollTargetLayout()
        }
        .contentMargins(50, for: .scrollContent)
        .scrollTargetBehavior(.viewAligned)
    }
}

struct PlaceholderMovieCard: View {
   let recWidth: CGFloat = UIScreen.main.bounds.width - 100
   let recHeight: CGFloat = 200
   
   var body: some View {
       ZStack(alignment: .bottomLeading) {
           Rectangle()
               .fill(Color.gray.opacity(0.2))
               .frame(width: recWidth, height: recHeight)
           
           LinearGradient(
               colors: [.black.opacity(0.7), .clear],
               startPoint: .bottom,
               endPoint: .center
           )
           
           VStack(alignment: .leading, spacing: 4) {
               // Title placeholder
               Rectangle()
                   .fill(Color.gray.opacity(0.3))
                   .frame(width: recWidth * 0.6, height: 20)
                   .cornerRadius(4)
               
               // Overview placeholder
               Rectangle()
                   .fill(Color.gray.opacity(0.3))
                   .frame(width: recWidth * 0.7, height: 16)
                   .cornerRadius(4)
           }
           .padding(15)
           
           // Loading indicator at center
           VStack(spacing: 12) {
               Image(systemName: "film")
                   .font(.system(size: 40))
                   .foregroundColor(.white.opacity(0.7))
               Text("Loading...")
                   .font(.pretendard(size: 13, family: .bold))
                   .foregroundColor(.white.opacity(0.7))
           }
           .frame(maxWidth: .infinity, maxHeight: .infinity)
       }
       .frame(width: recWidth, height: recHeight)
       .clipShape(RoundedRectangle(cornerRadius: 20))
       .shadow(radius: 10)
   }
}

struct MovieCard: View {
    let movie: MovieDomain
    let viewModel: HomeViewModel
    let recWidth: CGFloat = UIScreen.main.bounds.width - 100
    let recHeight: CGFloat = 200
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            // 배경 이미지
            CachedAsyncImage(
                url: movie.posterURL,
                targetSize: CGSize(width: recWidth, height: recHeight)
            ) {
                ZStack {
                    Color.gray.opacity(0.3)
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(0.7)
                }
            }
            .frame(width: recWidth, height: recHeight)
            
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


