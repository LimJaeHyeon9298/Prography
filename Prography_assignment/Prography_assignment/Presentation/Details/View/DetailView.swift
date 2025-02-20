//
//  DetailView.swift
//  Prography_assignment
//
//  Created by 임재현 on 2/17/25.
//

import SwiftUI

struct DetailView: View {
    let movie: MovieDomain
    @State var text: String = ""
    
    var body: some View {
        VStack(spacing: 0) {
            // 포스터 이미지 영역
            PosterImageView(posterURL: movie.posterURL)
                    .frame(height: UIScreen.main.bounds.height * 0.35)
            // 별점 영역
            RatingSection(rating: movie.rating)
                .padding(.top, 16)
            
            // 스크롤 영역
            DetailContent(movie: movie, text: $text)
        }
        .background(Color.white)
        .toolbar(.hidden, for: .navigationBar)
    }
}



// 별점 섹션
private struct RatingSection: View {
    let rating: Double
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<5) { index in
                Image(systemName: "star.fill")
                    .foregroundColor(index < Int(rating / 2) ? .yellow : .gray)
                    .font(.system(size: 36))
            }
        }
    }
}

// 장르 섹션
private struct GenreSection: View {
    let genreIds: [Int]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(genreIds, id: \.self) { genreId in
                    if let genre = MovieGenre(rawValue: genreId) {
                        Text(genre.name)
                            .font(.pretendard(size: 14, family: .medium))
                            .foregroundColor(.black)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(
                                Capsule()
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                    }
                }
            }
        }
    }
}

// 컨텐츠 영역
private struct DetailContent: View {
    let movie: MovieDomain
    @Binding var text: String
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // 제목 영역
                MovieTitleSection(movie: movie)
                
                // 장르 영역
                GenreSection(genreIds: movie.genreIds)
                
                // 줄거리 영역
                VStack(alignment: .leading, spacing: 12) {
                    Text("줄거리")
                        .font(.pretendard(size: 18, family: .bold))
                    
                    Text(movie.overview)
                        .font(.pretendard(size: 16, family: .regular))
                        .lineSpacing(4)
                        .foregroundColor(.black.opacity(0.8))
                }
                
                // 코멘트 영역
                VStack(alignment: .leading, spacing: 12) {
                    Text("Comment")
                        .font(.pretendard(size: 18, family: .bold))
                        .foregroundStyle(.black)
                    
                    TextEditor(text: $text)
                        .frame(height: 100)
                        .padding(.vertical, 8)
                        .background(.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                }
                
                Spacer(minLength: 32)
            }
            .padding(.horizontal, 16)
            .padding(.top, 24)
        }
    }
}

// 제목 섹션
private struct MovieTitleSection: View {
    let movie: MovieDomain
    
    var body: some View {
        Group {
            if movie.title.count < 15 {
                HStack(alignment: .lastTextBaseline, spacing: 8) {
                    Text(movie.title)
                        .font(.pretendard(size: 44, family: .bold))
                        .lineLimit(1)
                    
                    HStack(spacing: 4) {
                        Text("/")
                            .font(.pretendard(size: 24, family: .medium))
                        Text(String(format: "%.1f", movie.rating))
                            .font(.pretendard(size: 16, family: .bold))
                    }
                }
            } else {
                VStack(alignment: .leading, spacing: 8) {
                    Text(movie.title)
                        .font(.pretendard(size: 44, family: .bold))
                        .lineLimit(2)
                        .minimumScaleFactor(0.7)
                    
                    HStack(spacing: 4) {
                        Text(String(format: "%.1f", movie.rating))
                            .font(.pretendard(size: 16, family: .bold))
                        Text("/")
                            .font(.pretendard(size: 16, family: .medium))
                        Text("10")
                            .font(.pretendard(size: 16, family: .bold))
                    }
                }
            }
        }
    }
}

struct PosterImageView: View {
    let posterURL: URL?
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // 배경
                Color.black.opacity(0.1)
                
                // 포스터 이미지
                if let posterURL = posterURL {
                    AsyncImage(url: posterURL) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: geometry.size.width * 0.7)
                            .frame(maxWidth: .infinity)
                    } placeholder: {
                        defaultBackground(geometry: geometry)
                    }
                } else {
                    defaultBackground(geometry: geometry)
                }
            }
        }
    }
    
    @ViewBuilder
    private func defaultBackground(geometry: GeometryProxy) -> some View {
        Image(systemName: "film")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: geometry.size.width * 0.5)
            .foregroundColor(.gray)
    }
}
struct CustomTextView: UIViewRepresentable {
    @Binding var text: String
    @FocusState var isFocused: Bool
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.delegate = context.coordinator
        textView.font = .systemFont(ofSize: 16)
        textView.textColor = .white
        textView.backgroundColor = .clear
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        var parent: CustomTextView
        
        init(_ textView: CustomTextView) {
            self.parent = textView
        }
        
        func textViewDidChange(_ textView: UITextView) {
            parent.text = textView.text
        }
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            parent.isFocused = true
        }
                
        func textViewDidEndEditing(_ textView: UITextView) {
            parent.isFocused = false
        }
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content
    ) -> some View {
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }}

