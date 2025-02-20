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
            // 고정된 포스터 영역
            PosterImageView()
                .frame(height: UIScreen.main.bounds.height * 0.35)
            
            HStack(spacing: 8) {
                ForEach(0..<5) { index in
                    Image(systemName: "star.fill")
                        .foregroundColor(.gray)
                        .font(.system(size: 36))
                }
            }
            .padding(.top, 16)
            
            
            // 스크롤되는 상세 정보 영역
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // 별점 부분
                    
                    // 타이틀 부분
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
                        } else { // 긴 제목일 경우
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
                    
                    HStack(spacing: 8) {
                        ForEach(["Genre", "Genre", "Genre", "Genre"], id: \.self) { genre in
                            Text(genre)
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
                    
                    // 영화 설명 섹션
                    VStack(alignment: .leading, spacing: 16) {
                        Text(movie.overview)
                            .font(.pretendard(size: 16, family: .regular))
                            .lineSpacing(4)
                            .foregroundColor(.black.opacity(0.8))
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Comment")
                            .font(.pretendard(size: 16, family: .bold))
                            .foregroundStyle(.black)
                        
                        TextEditor(text: $text)
                            .frame(height: 100)
                            .padding(.vertical, 8)
                            .background(.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(.gray, lineWidth: 0.5)
                            )
                    }
                    
                    
                    
                    
                }
                .padding(.horizontal, 16)
            }
        }
        .background(Color.white)
        .toolbar(.hidden, for: .navigationBar)
    }
}




struct PosterImageView: View {
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                Rectangle()
                    .fill(Color.gray.opacity(0.7))
                    .frame(width: geometry.size.width * 0.25)
                
                Image(systemName: "pencil")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: geometry.size.width * 0.5)
                
                Rectangle()
                    .fill(Color.gray.opacity(0.7))
                    .frame(width: geometry.size.width * 0.25)
            }
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.gray.opacity(0.7),
                        Color.white.opacity(0.7)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
        }
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

