//
//  MainCoordinator.swift
//  NQueens
//
//  Created by Branimir Markovic on 9. 2. 2026..
//


import Observation
import SwiftUI

@Observable
final class MainCoordinator {
    
    var path: NavigationPath = NavigationPath()
    var sheet: SheetDestination?
    
    func push(to destination: PushDestination) {
        path.append(destination)
    }
    
    func pop() {
        path.removeLast()
    }
    
    func presentSheet(_ destination: SheetDestination) {
        sheet = destination
    }
    
    func dismissSheet() {
        sheet = nil
    }
    
    
}
