//
//  ContentView.swift
//  VPN SafetySurf
//
//  Created by Алексей Трушковский on 27.10.2021.
//

import SwiftUI

struct LoadingView: View {
    @ObservedObject var viewModel: LoadingViewModel
    @State var test = true
    
    init(viewModel: LoadingViewModel) {
        self.viewModel = viewModel
        self.viewModel.startLoading()
    }
    
    var body: some View {
        ZStack {
            Color(hex: "F3F5F7").edgesIgnoringSafeArea(.all)
            
            GeometryReader { geometry in
                VStack(alignment: .center) {
                    Spacer()
                    HStack(alignment: .center, spacing: 0) {
                        Spacer()
                        Image("vpnAppIcon").resizable()
                            .scaledToFit().foregroundColor(.black).font(.system(size: geometry.size.width * 0.2, weight: .bold))
                            .frame(width: geometry.size.width * 0.2, height: geometry.size.width * 0.2).scaledToFit().offset(y: test ? 0 : -80)
                            .animation(.interpolatingSpring(stiffness: 350, damping: 5, initialVelocity: 10))
                        
                        Spacer()
                    }
                    Text("SAFETY SURF").font(Font.custom("Antonio-Light", size: 25)).gradientForeground(colors: [Color(hex: "64D2FF"), Color(hex:"5E5CE6")])
                    Spacer()
                }
            }
        }.present($viewModel.activateMainScreen, view: MainView(viewModel: MainViewModel()))
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView(viewModel: LoadingViewModel())
    }
}

extension View {
    public func gradientForeground(colors: [Color]) -> some View {
        self.overlay(LinearGradient(gradient: .init(colors: colors),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing))
            .mask(self)
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
