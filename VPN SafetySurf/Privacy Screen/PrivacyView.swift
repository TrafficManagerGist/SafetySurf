//
//  PrivacyView.swift
//  VPN SafetySurf
//
//  Created by Алексей Трушковский on 10.11.2021.
//

import SwiftUI

struct PrivacyView: View {
    @Binding var isPrivacyPresented: Bool
    
    var body: some View {
        ZStack {
            Color(hex: "F3F5F7").edgesIgnoringSafeArea(.all)
            
            
            GeometryReader { geometry in
                VStack(alignment: .center) {
                    Text("Privacy Policy")
                        .padding(.bottom, 20.0).font(Font.custom("Antonio-Bold", size: 30)).foregroundColor(Color(hex: "000"))
                    Text("1. We dont collect personal information such as your name, email address, physical address calendar entries, contact entries, files, photos, etc.\n2. We dont collect information about your use of our apps, information that is of an anonymous nature, type of mobile device you use, your mobile devices unique device ID, the IP address of your mobile, your mobile operating system, and information about the way you use the application.").font(Font.custom("Antonio-Light", size: 20)).foregroundColor(Color(hex: "000"))
                    
                    Spacer()
                    Button(action: {
                        UserDefaults.standard.set(true, forKey: "notFirst")
                        isPrivacyPresented = false
                    }) {
                        Text("Continue")
                            .font(Font.custom("Antonio-Light", size: 20))
                            .frame(width: geometry.size.width * 0.97, height: geometry.size.height/9)
                            .background(Color(hex: "FFF"))
                            .foregroundColor(Color(hex: "000"))
                            .clipShape(RoundedRectangle(cornerRadius: 40))
                            .frame(width: geometry.size.width, height: geometry.size.height/8)
                    }
                }
            }.padding(.horizontal, 20).padding(.vertical, 20)
            
        }
    }
}
