//
//  TabItem.swift
//  Prography_assignment
//
//  Created by 임재현 on 2/18/25.
//

import Foundation

enum TabItem {
    case home
    case myPage
    
    var title: String {
        switch self {
        case .home:
            return "HOME"
        case .myPage:
            return "MY"
        }
    }
    
    func icon(isSelected: Bool) -> String {
        switch self {
        case .home:
            return isSelected ? "house-fill" : "house"
        case .myPage:
            return isSelected ? "Star-fill" : "Star"
        }
    }
    
    
}
