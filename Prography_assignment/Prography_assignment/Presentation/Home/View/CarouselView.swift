//
//  CarouselView.swift
//  Prography_assignment
//
//  Created by 임재현 on 2/18/25.
//

import SwiftUI


struct CarouselView: View {
    private var colorsArr: [Color] = [.red, .green, .yellow, .blue, .orange, .accentColor, .cyan, .brown, .indigo]
    
    var body: some View {
        ScrollView(.horizontal,showsIndicators: false) {
            HStack(spacing: 25) {
                ForEach(0..<colorsArr.count, id: \.self) { index in
                    RoundedRectangle(cornerRadius: 20)
                        .fill(colorsArr[index])
                        .shadow(radius: 5, x: 5, y: 5)
                        .frame(width: UIScreen.main.bounds.width - 100, height: 200)
                        .scrollTransition { content, phase in
                            content
                                .opacity(phase.isIdentity ? 1 : 0.5)
                                .scaleEffect(y: phase.isIdentity ? 1 : 0.7)
                        }
                }
            }
            .scrollTargetLayout()
            
        }
        .contentMargins(50, for: .scrollContent)
        .scrollTargetBehavior(.viewAligned)
    }
}


