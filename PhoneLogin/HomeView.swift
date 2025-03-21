//
//  HomeView.swift
//  PhoneLogin
//
//  Created by Martí Espinosa Farran on 3/19/25.
//

import SwiftUI
import FirebaseAuth

struct HomeView: View {
    @ObservedObject var vm: ViewModel

    var body: some View {
        VStack(spacing: 32) {
            Label("Authentication successful", systemImage: "checkmark.seal.fill")
                .foregroundColor(.green)
            
            if vm.isLoading {
                ProgressView()
            }
            
            Button("Log Out") {
                vm.logOut()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

#Preview {
    HomeView(vm: ViewModel())
}
