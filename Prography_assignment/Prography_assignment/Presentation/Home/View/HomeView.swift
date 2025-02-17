//
//  HomeView.swift
//  Prography_assignment
//
//  Created by 임재현 on 2/17/25.
//

import SwiftUI

struct HomeView: View {
    
    let apiKey = Bundle.main.infoDictionary?["APIKey"]
     as! String
    
    var body: some View {
        Text("\(apiKey)")
            .font(.pretendard(size: 16, family: .semibold))
            .foregroundStyle(.logo)
    }
}

#Preview {
    HomeView()
}
