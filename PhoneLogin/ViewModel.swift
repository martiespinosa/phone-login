//
//  ViewModel.swift
//  PhoneLogin
//
//  Created by Martí Espinosa Farran on 3/19/25.
//

import Foundation
import FirebaseAuth

class ViewModel: ObservableObject {
    @Published var isAuthenticated: Bool = false
    @Published var isLoading: Bool = false
    @Published var prefix: String = ""
    @Published var phoneNumber: String = ""
    @Published var verificationCode: String = ""
    @Published var verificationID: String? = nil
    
    init() {
        // Check if user is already authenticated
        isAuthenticated = Auth.auth().currentUser != nil
    }
    
    func sendVerificationCode() {
        isLoading = true
        let formattedPrefix = prefix.hasPrefix("+") ? prefix : "+" + prefix
        let cleanNumber = phoneNumber.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        let fullPhoneNumber = "\(formattedPrefix)\(cleanNumber)"
        
        print("Intentando verificar: \(fullPhoneNumber)")
        
        Auth.auth().settings?.appVerificationDisabledForTesting = false
        
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
    
    func verifyCode() {
        isLoading = true
        guard let verificationID = verificationID else { return }
        
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID,
            verificationCode: verificationCode
        )
        
        Auth.auth().signIn(with: credential) { (authResult, error) in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error al verificar el código: \(error.localizedDescription)")
                    self.isLoading = false
                    return
                }
                
                self.isAuthenticated = true
                self.isLoading = false
            }
        }
    }
    
    func logOut() {
        isLoading = true
        do {
            try Auth.auth().signOut()
            DispatchQueue.main.async {
                self.isAuthenticated = false
                self.isLoading = false
                // Reset verification data
                self.verificationID = nil
                self.verificationCode = ""
            }
        } catch let error {
            print("Error signing out: \(error.localizedDescription)")
            DispatchQueue.main.async {
                self.isLoading = false
            }
        }
    }
}
