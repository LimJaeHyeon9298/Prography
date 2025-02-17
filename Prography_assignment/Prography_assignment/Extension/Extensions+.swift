//
//  Extensions+.swift
//  Prography_assignment
//
//  Created by 임재현 on 2/17/25.
//

import SwiftUI

// MARK: - 커스텀 폰트
extension Font {
    enum Family: String {
        case bold,medium,regular,semibold
    }
    
    static func pretendard(size: CGFloat, family: Family) -> Font {
        return Font.custom("Pretendard-\(family)", size: size)
    }
}
