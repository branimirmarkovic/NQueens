//
//  AppTheme.swift
//  NQueens
//
//  Created by Branimir Markovic on 9. 2. 2026..
//

import SwiftUI

enum AppTheme {
    enum Colors {
        static let boardBackground = Color(UIColor.secondarySystemBackground)
        static let boardBorder = Color.secondary.opacity(0.3)
        static let cellLight = Color(UIColor.systemBackground)
        static let cellDark = Color(UIColor.systemGray6)
        static let highlightFill = Color.green.opacity(0.35)
        static let highlightBorder = Color.green
        static let errorBackground = Color.red.opacity(0.85)
        static let errorText = Color.white
        static let queen = Color.yellow
    }
    
    enum Icons {
        static let queen = Image(systemName: "crown.fill")
        static let reset = Image(systemName: "arrow.counterclockwise")
        static let error = Image(systemName: "exclamationmark.triangle.fill")
    }
}
