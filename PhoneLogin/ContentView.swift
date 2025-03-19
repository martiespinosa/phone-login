//
//  ContentView.swift
//  PhoneLogin
//
//  Created by Martí Espinosa Farran on 3/12/25.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    
    @State private var prefix: String = ""
    @State private var phoneNumber: String = ""
    @State private var verificationCode: String = ""
    @State private var isAuthenticated: Bool = false
    @State private var verificationID: String? = nil
    @State private var isLoading: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                TextField("Pref", text: $prefix)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.phonePad)
                    .frame(width: 60)
                TextField("Phone Number", text: $phoneNumber)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.numberPad)
                    .textContentType(.telephoneNumber)
                Button("Auth") { sendVerificationCode() }
                    .buttonStyle(.borderedProminent)
            }
            
            if verificationID != nil {
                HStack {
                    TextField("Verification Code", text: $verificationCode)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.numberPad)
                    
                    Button("Verify") { verifyCode() }
                        .buttonStyle(.borderedProminent)
                }
            }
            
            if isAuthenticated {
                Label("Authentication successful", systemImage: "checkmark.seal.fill")
                    .foregroundColor(.green)
                    .padding(.top, 32)
            }
            
            if isLoading { ProgressView() }
        }
        .padding()
        .font(.system(.headline, design: .monospaced))
        .toolbar {
            ToolbarItem(placement: .keyboard) {
                HStack {
                    Spacer()
                    Button("OK") { hideKeyboard() }
                        .font(.headline)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
    }
        
    private func sendVerificationCode() {
        isLoading = true
        let formattedPrefix = prefix.hasPrefix("+") ? prefix : "+" + prefix
        let cleanNumber = phoneNumber.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        let fullPhoneNumber = "\(formattedPrefix)\(cleanNumber)"
        
        print("Intentando verificar: \(fullPhoneNumber)")
        
        PhoneAuthProvider.provider().verifyPhoneNumber(fullPhoneNumber, uiDelegate: nil) { verificationID, error in
            DispatchQueue.main.async {
                self.isLoading = false
                
                if let error = error {
                    print("Error en el envío del SMS: \(error.localizedDescription)")
                    return
                }
                
                self.verificationID = verificationID
            }
        }
    }
    
    private func verifyCode() {
        isLoading = true
        guard let verificationID = verificationID else { return }
        
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID,
            verificationCode: verificationCode
        )
        
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                print("Error al verificar el código: \(error.localizedDescription)")
                return
            }
            
            self.isAuthenticated = true
            isLoading = false
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
    ContentView()
}
