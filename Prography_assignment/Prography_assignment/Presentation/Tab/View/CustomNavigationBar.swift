//
//  CustomNavigationBar.swift
//  Prography_assignment
//
//  Created by 임재현 on 2/18/25.
//

import SwiftUI

struct LogoView: View {
    var body: some View {
        HStack {
            Text("Prography")
                .font(.pretendard(size: 24, family: .bold))
                .foregroundStyle(Color.logo)
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .background(Color.white)
        }
    }
}

struct CustomNavigationBar<T: ObservableObject>: View where T: CoordinatorProtocol {
    @ObservedObject var coordinator: T
    
    init(coordinator: T) {
        self.coordinator = coordinator
    }

    var body: some View {
        HStack(spacing: 16) {
            Button(action: {
                coordinator.navigationPath.removeLast()
            }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(Color.black)
            }
        
            Text("Prography")
                .font(.pretendard(size: 24, family: .bold))
                .foregroundStyle(Color.logo)
                .frame(maxWidth: .infinity)

            Button(action: {
            }) {
                Image(systemName: "ellipsis")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(Color.black)
            }
        }
        .padding(.horizontal, 16)
        .frame(height: 44)
        .background(Color.white)
    }
}
