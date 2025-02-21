//
//  DetailView.swift
//  Prography_assignment
//
//  Created by 임재현 on 2/17/25.
//

import SwiftUI
import SwiftData

enum NavigationSource {
    case home
    case myPage
}

struct DetailView<T: ObservableObject>: View where T: CoordinatorProtocol {
    @StateObject var viewModel: DetailViewModel
    @ObservedObject var coordinator: T
    
    @State private var textEditorHeight: CGFloat = 34
    @State private var maxEditorHeight: CGFloat = 170
    @State private var keyboardHeight: CGFloat = 0
    @State private var isEditing = false
    
       
    
    var body: some View {
        VStack {
            CustomNavigationBar(
                coordinator: coordinator,
                hideRightButton: viewModel.hasExistingReview,
                onEdit: {
                    // 수정 모드로 전환하는 로직
                    viewModel.isEditing = true
                },
                onDelete: {
                    // 삭제 확인 알림 표시
                    viewModel.showingDeleteConfirmation = true
                }
            )
            
            
            ScrollView {
                VStack(spacing: 0) {
                    // 포스터 이미지 영역
                    PosterImageView(posterURL: viewModel.posterURL)
                        .frame(height: UIScreen.main.bounds.height * 0.35)
                    
         
                    if viewModel.hasExistingReview {
                                            // 기존 리뷰의 별점은 RatingSection을 비활성화로 사용
                                            RatingSection(userRating: .constant(viewModel.userRating))  // constant binding으로 수정 불가능하게
                                                .allowsHitTesting(false)
                                                .padding(.top, 16)
                                        } else {
                                            // 새로운 별점 입력 UI
                                            RatingSection(userRating: $viewModel.userRating)
                                                .padding(.top, 16)
                                        }
                    
                    // 컨텐츠 영역
                    VStack(alignment: .leading, spacing: 24) {
                        MovieTitleSection(title: viewModel.title, rating: viewModel.rating)
                        GenreSection(genres: viewModel.genres)
                        
                        // 줄거리 영역
                        VStack(alignment: .leading, spacing: 12) {
                            Text("줄거리")
                                .font(.pretendard(size: 18, family: .bold))
                            Text(viewModel.overview)
                                .font(.pretendard(size: 16, family: .regular))
                                .lineSpacing(4)
                        }
                        
                        // 코멘트 영역
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Comment")
                                .font(.pretendard(size: 18, family: .bold))
                            
                            if viewModel.hasExistingReview {
                                ExistingReviewView(
                                    rating: viewModel.userRating,
                                    comment: viewModel.comment
                                )
                            } else {
                                NewReviewEditorView(
                                    text: $viewModel.comment,
                                    userRating: $viewModel.userRating,
                                    textEditorHeight: $textEditorHeight,
                                    onSubmit: {
                                        viewModel.saveReview(
                                            title: viewModel.title,
                                            rating: viewModel.userRating,
                                            comment: viewModel.comment
                                        )
                                    }
                                )
                            }
                        }
                        
                        Spacer(minLength: 32)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 24)
                }
            }
        }
        .alert("리뷰 삭제", isPresented: $viewModel.showingDeleteConfirmation) {
            Button("삭제", role: .destructive) {
                viewModel.deleteReview()
            }
            Button("취소", role: .cancel) {}
        } message: {
            Text("이 리뷰를 정말 삭제하시겠습니까?")
        }
        .alert("삭제 완료", isPresented: $viewModel.showingDeleteAlert) {
            Button("확인", role: .cancel) {

              coordinator.navigationPath.removeLast()
            }
        } message: {
            Text("리뷰가 성공적으로 삭제되었습니다.")
        }
        .alert("저장 완료", isPresented: $viewModel.showingSaveAlert) {
                   Button("확인", role: .cancel) { }
               } message: {
                   Text("리뷰가 저장되었습니다!")
               }
        .background(Color.white)
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            viewModel.checkExistingReview()
            viewModel.fetchMovieDetail()
            setupKeyboardObservers()
        }
        .onDisappear {
            hideKeyboard()
        }
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        isEditing = false
    }

    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notification in
            if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                keyboardHeight = keyboardFrame.height
                isEditing = true
            }
        }

        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) {
            _ in keyboardHeight = 0
            isEditing = false
        }
    }

    private func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(self)
    }
}






struct ExistingReviewView: View {
    let rating: Int
    let comment: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.gray.opacity(0.1))
                .overlay(
                    Text(comment)
                        .font(.pretendard(size: 16, family: .regular))
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                        .padding()
                        .foregroundColor(.black)
                )
                .frame(minHeight: 100)
        }
    }
}

// 새 리뷰 작성용 View
struct NewReviewEditorView: View {
    @Binding var text: String
    @Binding var userRating: Int
    @Binding var textEditorHeight: CGFloat
    let onSubmit: () -> Void
    
    var body: some View {
        HStack(spacing: 10) {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .strokeBorder(Color.secondary, lineWidth: 1)
                    .background(Color.white)
                    .frame(height: max(50, textEditorHeight))
                
                HStack {
                    DynamicHeightTextEditor(
                        text: $text,
                        height: $textEditorHeight,
                        maxEditorHeight: 170
                    )
                    .frame(height: min(textEditorHeight, 170))
                    .padding(.vertical, 8)
                    
                    Spacer()
                    
                    Button(action: onSubmit) {
                        Image(systemName: "paperplane.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                    }
                    .disabled(text.isEmpty || userRating == 0)
                }
                .padding(.horizontal, 12)
            }
            .padding(.bottom, 8)
        }
        .padding(.horizontal)
    }
}


// 별점 섹션
private struct RatingSection: View {
    @Binding var userRating: Int
    
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(1...5, id: \.self) { index in
                Image(systemName: "star.fill")
                    .foregroundColor(index <= userRating ? .red : .gray)
                    .font(.system(size: 36))
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            if userRating == index {
                                userRating = 0
                            } else {
                                userRating = index
                            }
                        }
                    }
            }
        }
    }
}

// 장르 섹션
private struct GenreSection: View {
    let genres: [String]  // API에서 받아온 장르 이름들
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(genres, id: \.self) { genre in
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
        }
    }
}

// 컨텐츠 영역
private struct DetailContent: View {
    @ObservedObject var viewModel: DetailViewModel
    @Binding var text: String
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // 제목 영역
                MovieTitleSection(
                    title: viewModel.title,
                    rating: viewModel.rating
                )
                
                // 장르 영역
                GenreSection(genres: viewModel.genres)
                
                // 줄거리 영역
                VStack(alignment: .leading, spacing: 12) {
                    Text("줄거리")
                        .font(.pretendard(size: 18, family: .bold))
                    
                    Text(viewModel.overview)
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
    let title: String
    let rating: Double

    var body: some View {
        Group {
            if title.count < 15 {
                HStack(alignment: .lastTextBaseline, spacing: 8) {
                    Text(title)
                        .font(.pretendard(size: 34, family: .bold))
                        .lineLimit(1)
                    
                    HStack(spacing: 4) {
                        Text("/")
                            .font(.pretendard(size: 24, family: .medium))
                        Text(String(format: "%.1f",rating))
                            .font(.pretendard(size: 16, family: .bold))
                    }
                }
            } else {
                VStack(alignment: .leading, spacing: 8) {
                    Text(title)
                        .font(.pretendard(size: 44, family: .bold))
                        .lineLimit(2)
                        .minimumScaleFactor(0.7)
                    
                    HStack(spacing: 4) {
                        Text(String(format: "%.1f", rating))
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


struct DynamicHeightTextEditor: UIViewRepresentable {
    @Binding var text: String
    @Binding var height: CGFloat
    var maxEditorHeight: CGFloat

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.isScrollEnabled = false
        textView.font = UIFont.systemFont(ofSize: 17)
        textView.backgroundColor = .clear
        textView.delegate = context.coordinator
        textView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        textView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        textView.inputAssistantItem.leadingBarButtonGroups = []
                textView.inputAssistantItem.trailingBarButtonGroups = []
                textView.autocorrectionType = .no
                textView.autocapitalizationType = .none
                textView.spellCheckingType = .no
                textView.smartQuotesType = .no
                textView.smartDashesType = .no
        
        
        
        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
        DynamicHeightTextEditor.recalculateHeight(view: uiView, result: $height, maxEditorHeight: maxEditorHeight)
        uiView.isScrollEnabled = height >= maxEditorHeight
    }

    static func recalculateHeight(view: UIView, result: Binding<CGFloat>, maxEditorHeight: CGFloat) {
        let size = view.sizeThatFits(CGSize(width: view.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
        DispatchQueue.main.async {
            result.wrappedValue = min(size.height, maxEditorHeight)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    class Coordinator: NSObject, UITextViewDelegate {
        var parent: DynamicHeightTextEditor

        init(parent: DynamicHeightTextEditor) {
            self.parent = parent
        }

        func textViewDidChange(_ textView: UITextView) {
            parent.text = textView.text
            DynamicHeightTextEditor.recalculateHeight(view: textView, result: parent.$height, maxEditorHeight: parent.maxEditorHeight)
        }
    }
}
