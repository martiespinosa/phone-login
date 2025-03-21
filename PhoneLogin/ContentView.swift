//
//  ContentView.swift
//  PhoneLogin
//
//  Created by Martí Espinosa Farran on 3/12/25.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var vm: ViewModel
    
    var body: some View {
        NavigationStack {
            if vm.isAuthenticated {
                HomeView(vm: vm)
            } else {
                AuthView(vm: vm)
            }
        }
    }
}

#Preview {
    ContentView(vm: ViewModel())
}
