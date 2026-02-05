//
//  StartScreenView.swift
//  NQueens
//
//  Created by Branimir Markovic on 5. 2. 2026..
//

import SwiftUI
import Observation

@Observable
class StartScreenViewModel {
    var numberOfQueens: Int = 3
}

struct StartScreenView: View {
    @State var viewModel: StartScreenViewModel
    var body: some View {
           Form {
               Section("Pick the number of queens") {
                   Picker("Broj", selection: $viewModel.numberOfQueens) {
                       ForEach(3...25, id: \.self) { value in
                           Text("\(value)").tag(value)
                       }
                   }
                   .pickerStyle(.wheel)
                   .frame(height: 180)
               }

               Section {
                   Button("Start") {
                      
                   }
                   .frame(maxWidth: .infinity, alignment: .center)
               }
           }
           .navigationTitle("Start")
       }
}

#Preview {
    StartScreenView(viewModel: .init())
}
