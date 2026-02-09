//
//  NQueensApp.swift
//  NQueens
//
//  Created by Branimir Markovic on 5. 2. 2026..
//

import SwiftUI

@main
struct NQueensApp: App {
    var body: some Scene {
        WindowGroup {
            RootView(
                coordinator: MainCoordinator(),
                viewFactory: ViewFactory(),
                applicationEnvironment: ApplicationEnvironment.shared
            )
        }
    }
}
