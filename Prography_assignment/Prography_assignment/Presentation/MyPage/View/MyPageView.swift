//
//  MyPageView.swift
//  Prography_assignment
//
//  Created by 임재현 on 2/17/25.
//

import SwiftUI

//struct MyPageView: View {
//    @ObservedObject var coordinator: MyPageCoordinator
//    @Binding var hideTabBar: Bool
//    @State private var selectedTab = "평점" // 드롭다운 상태 관리를 위한 State
//    
//    let columns = [
//        GridItem(.flexible(),spacing: 10),
//        GridItem(.flexible(),spacing: 10),
//        GridItem(.flexible(),spacing: 10)
//    ]
//    
//    var body: some View {
//        NavigationStack(path: $coordinator.navigationPath) {
//            ZStack(alignment: .top) {
//                // 메인 컨텐츠
//                ScrollView {
//                    VStack(spacing: 0) {
//                        // 드롭다운 자리 차지를 위한 빈 공간
//                        Color.clear
//                            .frame(height: 50)  // DropTow의 헤더 높이만큼
//                        
//                        LazyVGrid(columns: columns, spacing: 10) {
//                            ForEach(0..<10) { index in // 예시 데이터
//                                VStack(alignment: .leading, spacing: 8) {
//                                    Image(systemName: "photo")  // 예시 이미지
//                                        .resizable()
//                                        .aspectRatio(contentMode: .fill)
//                                        .frame(width: (UIScreen.main.bounds.width - 40) / 3, height: 150)
//                                        .clipped()
//                                        .cornerRadius(8)
//                                    
//                                    Text("영화 제목 \(index)")
//                                        .font(.subheadline)
//                                        .lineLimit(1)
//                                    
//                                    HStack(spacing: 2) {
//                                        Image(systemName: "star.fill")
//                                            .foregroundColor(.yellow)
//                                        Text("4.5")
//                                            .font(.caption)
//                                    }
//                                }
//                                .frame(maxWidth: .infinity)
//                            }
//                        }
//                        .padding(.horizontal,10)
//                    }
//                }
//                
//                // 드롭다운 메뉴
//                DropTow()
//                    .zIndex(1)  // 다른 컨텐츠 위에 표시
//            }
//            .navigationDestination(for: MyPageRoute.self) { route in
//                coordinator.view(for: route)
//            }
//        }
//        .onChange(of: coordinator.navigationPath.count) { count in
//            hideTabBar = count > 0
//        }
//    }
//}

struct MyPageView: View {
    @ObservedObject var coordinator: MyPageCoordinator
    @Binding var hideTabBar: Bool
    
    let columns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]
    
    var body: some View {
        NavigationStack(path: $coordinator.navigationPath) {
            ZStack(alignment: .top) { // ZStack을 사용하여 겹치도록
                // 기본 GridView (항상 같은 위치 유지)
                ScrollView {
                    VStack(spacing: 0) {
                        LazyVGrid(columns: columns, spacing: 10) {
                            ForEach(0..<10) { index in
                                VStack(alignment: .leading, spacing: 4) {
                                    Image(systemName: "photo")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: (UIScreen.main.bounds.width - 40) / 3, height: 150)
                                        .clipped()
                                        .cornerRadius(8)
                                    
                                    Text("영화 제목 \(index)")
                                        .font(.caption)
                                        .lineLimit(1)
                                    
                                    HStack(spacing: 2) {
                                        ForEach(0..<5) { index in
                                               Image(systemName: "star.fill")
                                                   .foregroundColor(index < Int(4.5) ? .yellow : .gray.opacity(0.3))
                                                   .font(.caption)
                                           }
                                    }
                                }
                                .frame(maxWidth: .infinity)
                            }
                        }
                        .padding(.horizontal, 10)
                        .padding(.top, 100)  // DropTow 헤더 높이만큼만 패딩
                        .padding(.bottom, 150)
                    }
                }
                .ignoresSafeArea(.container, edges: .bottom)
                
                // DropTow (최상단에 배치)
                VStack {
                    DropTow()
                        .background(Color.white)  // 배경 추가
                        .zIndex(2)  // 항상 위에 표시
                    Spacer()  // 나머지 공간 채우기
                }
            }
            .navigationDestination(for: MyPageRoute.self) { route in
                coordinator.view(for: route)
            }
        }
        .onChange(of: coordinator.navigationPath.count) { count in
            hideTabBar = count > 0
        }
    }
}


struct DropMenu: Identifiable {
    var id = UUID()
    var title: String
}

let drop = [
    DropMenu(title: "Item1"),
    DropMenu(title: "Item2"),
    DropMenu(title: "Item3"),
    DropMenu(title: "Item4"),
    DropMenu(title: "Item5"),
    DropMenu(title: "Item6")
    
]

struct DropTow: View {
    @State private var show = false
    @State private var selectedItem = "Item1"
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                DropdownHeader(
                    title: $selectedItem,
                    isExpanded: $show
                )
            }
            .background(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray, lineWidth: 1)
            )
            .cornerRadius(10)
            
            if show {
                VStack {
                    Divider()
                        .background(Color.gray)
                    
                    DropdownContent(
                        selectedItem: $selectedItem,
                        isExpanded: $show
                    )
                }
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 1)
                )
                .cornerRadius(10)
                .offset(y: 60) // 헤더로부터의 거리 조절
                .zIndex(1)
            }
        }
        .animation(.spring(), value: show)
        .padding()
    }
}

struct DropdownHeader: View {
    @Binding var title: String
    @Binding var isExpanded: Bool
    
    var body: some View {
        HStack {
            Text(title)
                .font(.title2)
                .bold()
            
            Spacer()
            
            Image(systemName: "triangle.fill")
                .rotationEffect(.degrees(isExpanded ? 0 : 90))
        }
        .padding()
        .onTapGesture {
            withAnimation {
                isExpanded.toggle()
            }
        }
    }
}

struct DropdownContent: View {
    @Binding var selectedItem: String
    @Binding var isExpanded: Bool
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                ForEach(["Item1", "Item2", "Item3", "Item4", "Item5", "Item6"], id: \.self) { item in
                    Button(action: {
                        selectedItem = item
                        isExpanded = false
                    }) {
                        HStack {
                            Text(item)
                                .foregroundColor(.black)
                            Spacer()
                        }
                        .padding()
                    }
                    
                    if item != "Item6" {
                        Divider()
                    }
                }
            }
        }
        .frame(maxHeight: 320)
    }
}


