//
//  LoginView.swift
//  VPN SafetySurf
//
//  Created by Алексей Трушковский on 12.11.2021.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel: LoginViewModel
    @State var isOpen = false
    @State private var isSharePresented: Bool = false
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        GeometryReader { geometry in
        }.edgesIgnoringSafeArea(.all)
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(viewModel: LoginViewModel())
    }
}
