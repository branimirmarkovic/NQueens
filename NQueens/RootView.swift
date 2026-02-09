//
//  RootView.swift
//  NQueens
//
//  Created by Branimir Markovic on 9. 2. 2026..
//


import SwiftUI

struct RootView: View {
    @State var coordinator: MainCoordinator
    let viewFactory: ViewFactory
    let applicationEnvironment: ApplicationEnvironment
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            viewFactory.rootView()
                .navigationDestination(for: PushDestination.self) { destination in
                    viewFactory.view(for: destination)
                }
        }.environment(coordinator)
    }
}
