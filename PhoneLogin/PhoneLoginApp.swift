//
//  PhoneLoginApp.swift
//  PhoneLogin
//
//  Created by Martí Espinosa Farran on 3/12/25.
//

import SwiftUI
import FirebaseCore

@main
struct PhoneLoginApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject private var viewModel = ViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView(vm: viewModel)
                .font(.system(.headline, design: .monospaced))
        }
    }
}
