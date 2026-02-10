//
//  Container.swift
//  NQueens
//
//  Created by Branimir Markovic on 9. 2. 2026..
//

import Foundation
import NQueenEngine


final class ApplicationEnvironment {
    static let shared = ApplicationEnvironment()
    
    lazy var userDefaultsStorage: UserDefaultsGameStorageService = UserDefaultsGameStorageService()
    
    private init() {}
}


