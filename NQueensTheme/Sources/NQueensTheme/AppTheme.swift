//
//  AppTheme.swift
//  NQueensTheme
//
//  Created by Branimir Markovic on 9. 2. 2026..
//

import SwiftUI

public enum AppTheme {
    public enum Colors {
        public static let boardBackground = Color(UIColor.secondarySystemBackground)
        public static let boardBorder = Color.secondary.opacity(0.3)
        public static let cellLight = Color(UIColor.systemBackground)
        public static let cellDark = Color(UIColor.systemGray6)
        public static let highlightFill = Color.green.opacity(0.35)
        public static let highlightBorder = Color.green
        public static let conflictFill = Color.red.opacity(0.25)
        public static let conflictBorder = Color.red
        public static let errorBackground = Color.red.opacity(0.85)
        public static let errorText = Color.white
        public static let queen = Color.yellow
    }
    
    public enum Icons {
        public static let queen = Image(systemName: "crown.fill")
        public static let reset = Image(systemName: "arrow.counterclockwise")
        public static let error = Image(systemName: "exclamationmark.triangle.fill")
    }
}
