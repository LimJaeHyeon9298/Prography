//
//  CustomNavigationBar.swift
//  Prography_assignment
//
//  Created by 임재현 on 2/18/25.
//

import SwiftUI

struct CustomNavigationBar: View {
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

#Preview {
    CustomNavigationBar()
}
