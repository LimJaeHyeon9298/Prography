//
//  CustomTabBar.swift
//  Prography_assignment
//
//  Created by 임재현 on 2/18/25.
//

import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: TabItem
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach([TabItem.home,TabItem.myPage],id: \.self) { tab in
                Button {
                    selectedTab = tab
                } label: {
                    VStack {
                        Image(tab.icon(isSelected: selectedTab == tab))
                        Text(tab.title)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                }
                .foregroundColor(selectedTab == tab ? .blue : .gray)
            }
        }
        .frame(maxWidth: .infinity)
        .background(.gray)
    }
}
