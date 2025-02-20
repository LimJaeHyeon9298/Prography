//
//  DetailView.swift
//  Prography_assignment
//
//  Created by 임재현 on 2/17/25.
//

import SwiftUI

struct DetailView: View {
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
               VStack(alignment: .leading, spacing: 12) {
                   // 별점 부분
                   
                   // 타이틀 부분
                   HStack {
                       HStack(alignment: .lastTextBaseline) {
                           Text("Title")
                               .font(.pretendard(size: 44, family: .bold))
                           
                           Text("/")
                               .font(.pretendard(size: 24, family: .medium))
                               .baselineOffset(4)
                           
                           Text("rate")
                               .font(.pretendard(size: 16, family: .bold))
                       }
                       Spacer()
                   }
                   
                   // 장르 Capsule
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
                       Text("""
                           쿠크가 테일즈와 함께 평화로운 일상을 보내던 초음속 고슴도치 소닉.
                           어느 날, 정체불명의 로봇이 나타나 테일즈를 파괴하려 합니다.
                           소닉은 친구를 구하기 위해 나서지만, 이것은 시작에 불과했습니다.
                           
                           전 세계를 위협하는 새로운 적이 등장하고,
                           소닉은 더 큰 위험에 맞서기 위해 새로운 동료들과 함께합니다.
                           과연 소닉과 친구들은 세상을 구할 수 있을까요?
                           
                           속도를 넘어선 모험이 시작됩니다.
                           더 강력해진 적과의 대결,
                           그리고 진정한 우정의 의미를 깨닫게 될 것입니다.
                           """)
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

