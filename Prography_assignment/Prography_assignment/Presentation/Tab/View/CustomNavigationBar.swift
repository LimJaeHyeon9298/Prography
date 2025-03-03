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
    var hideRightButton: Bool = false
    var onEdit: (() -> Void)?
    var onDelete: (() -> Void)?
    
    init(
        coordinator: T,
        hideRightButton: Bool = false,
        onEdit: (() -> Void)? = nil,
        onDelete: (() -> Void)? = nil
    ) {
        self.coordinator = coordinator
        self.hideRightButton = hideRightButton
        self.onEdit = onEdit
        self.onDelete = onDelete
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

            if hideRightButton {
                Menu {
                    Button(action: {
                        onEdit?()
                    }) {
                        Label("수정하기", systemImage: "pencil")
                    }
                    
                    Button(role: .destructive, action: {
                        onDelete?()
                    }) {
                        Label("삭제하기", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(Color.black)
                }
            } else {
                Color.clear.frame(width: 20, height: 20)
            }
        }
        .padding(.horizontal, 16)
        .frame(height: 44)
        .background(Color.white)
    }
}
