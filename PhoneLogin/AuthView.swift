//
//  AuthView.swift
//  PhoneLogin
//
//  Created by Martí Espinosa Farran on 3/19/25.
//

import SwiftUI

struct AuthView: View {
    @ObservedObject var vm: ViewModel
    
    var body: some View {
        VStack {
            HStack {
                TextField("Prefix", text: $vm.prefix)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.phonePad)
                    .frame(width: 80)
                TextField("Phone Number", text: $vm.phoneNumber)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.numberPad)
                    .textContentType(.telephoneNumber)
                Button("Auth") { vm.sendVerificationCode() }
                    .buttonStyle(.borderedProminent)
            }
            
            if vm.verificationID != nil {
                HStack {
                    TextField("Verification Code", text: $vm.verificationCode)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.numberPad)
                    
                    Button("Verify") { vm.verifyCode() }
                        .buttonStyle(.borderedProminent)
                }
            }
            
            if vm.isLoading { ProgressView() }
        }
        .padding()
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("OK") { hideKeyboard() }
                    .font(.headline)
            }
        }
    }
}

extension View {
    func hideKeyboard() {
        DispatchQueue.main.async {
            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                scene.windows.forEach { $0.endEditing(true) }
            }
        }
    }
}

#Preview {
    AuthView(vm: ViewModel())
}
