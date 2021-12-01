//
//  SettingsViewModel.swift
//  VPN SafetySurf
//
//  Created by Алексей Трушковский on 30.11.2021.
//

import SwiftUI
import Combine

class SettingsViewModel: ObservableObject {
    @Published var presentedAsModal = false
    @Published var buttonsNames = ["Terms of use", "Privacy Policy", "Contact us", "Rate App", "Share"]
    @Published var buttonsImages = ["doc.plaintext", "doc.circle", "person", "star.circle", "square.and.arrow.up"]
    
    init(presentedAsModal: Bool) {
        self.presentedAsModal = presentedAsModal
    }
}
