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

            TabView(selection: $selectedTab) {
                ForEach(0..<tabs.count, id: \.self) { index in
                    ScrollView(.vertical, showsIndicators: false) {
                        LazyVStack(spacing: 16) {
                                    ForEach(0..<10) { _ in
                                        MovieItemView()
                                            .frame(maxWidth: .infinity)
                                            .padding(.horizontal)
                                           
                                        
                                    }
                            
                        }
                        .padding(.vertical)
                        .padding(.bottom, 60)
                    }
                    .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))

        }
    }
    
    @Namespace private var namespace
}


struct MovieItemView: View {
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
