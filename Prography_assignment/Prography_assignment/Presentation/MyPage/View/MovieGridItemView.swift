//
//  MovieGridItemView.swift
//  Prography_assignment
//
//  Created by 임재현 on 2/20/25.
//

import SwiftUI


struct MovieGridItemView: View {
    let movie: MovieReview
    let onTapItem: (Int) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            AsyncImage(url: URL(string: movie.posterURL)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: (UIScreen.main.bounds.width - 40) / 3, height: 150)
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: (UIScreen.main.bounds.width - 40) / 3, height: 150)
                        .clipped()
                        .cornerRadius(8)
                case .failure:
                    Image(systemName: "photo")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: (UIScreen.main.bounds.width - 40) / 3, height: 150)
                        .clipped()
                        .cornerRadius(8)
                @unknown default:
                    Image(systemName: "photo")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: (UIScreen.main.bounds.width - 40) / 3, height: 150)
                        .clipped()
                        .cornerRadius(8)
                }
            }
            .onTapGesture {
                onTapItem(movie.movieId)
            }
                        
            
            Text(movie.title)
                .font(.caption)
                .lineLimit(1)
            
            HStack(spacing: 2) {
                ForEach(0..<5) { index in
                    Image(systemName: "star.fill")
                        .foregroundColor(index < Int(movie.rating) ? .yellow : .gray.opacity(0.3))
                        .font(.caption)
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
}

struct MovieItem: Identifiable {
    let id = UUID()
    let title: String
    let rating: Double
    let imageUrl: String
}



