//
//  DropDownView.swift
//  Prography_assignment
//
//  Created by 임재현 on 2/20/25.
//

import SwiftUI

struct DropMenu: Identifiable {
    var id = UUID()
    var title: String
    var rating: Int?
}

let drop = [
    DropMenu(title: "All", rating: nil),
    DropMenu(title: "★☆☆☆☆", rating: 1),
    DropMenu(title: "★★☆☆☆", rating: 2),
    DropMenu(title: "★★★☆☆", rating: 3),
    DropMenu(title: "★★★★☆", rating: 4),
    DropMenu(title: "★★★★★", rating: 5)
    
]

struct StarRatingView: View {
    let rating: Int
    let maxRating: Int = 5
    
    var body: some View {
        HStack(spacing: 4) {  // 별들 사이 간격 조정
            ForEach(0..<maxRating, id: \.self) { index in
                Image(systemName: "star.fill")
                    .foregroundColor(index < rating ? .red : .gray)
                    .font(.system(size: 16))  // 별 크기 조정
            }
        }
    }
}



struct DropdownView: View {
    @State private var show = false
    @State private var selectedItem = "All"
    @Binding var selectedRating: Int?
    
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
        .onChange(of: selectedItem) { newValue in

                    if newValue == "All" {
                        selectedRating = nil
                    } else {
                        // 별점 개수 계산 (예: "★★★☆☆" -> 3)
                        selectedRating = drop.first(where: { $0.title == newValue })?.rating
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
        Button(action: {
            isExpanded.toggle()
        }) {
            HStack {
                // 선택된 항목이 "All"인 경우와 별점인 경우를 구분
                if let selectedItem = drop.first(where: { $0.title == title }) {
                    if selectedItem.rating == nil {
                        Text("All")
                            .foregroundColor(.black)
                    } else {
                        StarRatingView(rating: selectedItem.rating!)
                    }
                }
                Spacer()
                Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                    .foregroundColor(.gray)
            }
            .frame(height: 44)
            .padding(.horizontal)
        }
    }
}

struct DropdownContent: View {
    @Binding var selectedItem: String
    @Binding var isExpanded: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(drop) { item in
                Button(action: {
                    selectedItem = item.title
                    isExpanded = false
                }) {
                    HStack {
                        if item.rating == nil {
                            Text("All")
                                .foregroundColor(.black)
                        } else {
                            StarRatingView(rating: item.rating!)
                        }
                        Spacer()
                    }
                    .frame(height: 44)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal)
                    .background(
                        selectedItem == item.title
                            ? Color.gray.opacity(0.1)
                            : Color.clear
                    )
                }
            }
        }
    }
}
