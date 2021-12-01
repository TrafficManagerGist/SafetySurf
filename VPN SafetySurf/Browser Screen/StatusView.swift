//
//  StatusView.swift
//  VPN SafetySurf
//
//  Created by Алексей Трушковский on 29.11.2021.
//

import SwiftUI
struct StatusView: View {
    @ObservedObject var viewModel: StatusViewModel
    
    init(viewModel: StatusViewModel) {
        self.viewModel = viewModel
        UITableView.appearance().separatorColor = .clear
        UITableView.appearance().backgroundColor = .clear
        UITableViewCell.appearance().backgroundColor = .clear
        UITableViewCell.appearance().selectionStyle = .none
    }
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color(hex: "5E5CE6"), Color(hex: "64D2FF")]), startPoint: .topLeading, endPoint: .bottomTrailing).edgesIgnoringSafeArea(.all)
            VStack {
                
                HStack {
                    Spacer()
                    Text("Status").font(.system(size: 30, weight: .semibold)).tracking(1).multilineTextAlignment(.center).foregroundColor(Color(hex: "fff"))
                    Spacer()
                }.padding(.top, 30)
                
//                HStack {
//                    List(identServers, id: \.id) { item in
//                        ZStack {
//                            RoundedRectangle(cornerRadius: 28)
//                                .fill(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
//                                .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.07999999821186066)), radius:24, x:0, y:16)
//                            HStack {
//                                ImageView(withURL: item.imageLink).padding()
//                                Text(item.location).font(.system(size: 20, weight: .semibold)).tracking(1).multilineTextAlignment(.center).foregroundColor(Color(hex: "000"))
//                                Spacer()
//                            }
//                        }.onTapGesture {
//                            viewModel.saveConfig(config: item)
//                            self.presentationMode.wrappedValue.dismiss()
//                        }
//                    }
//                }.padding()
                HStack {
                    Spacer()
                    Button {
                        VPNLogic().disconnectVPN()
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 28)
                                .fill(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
                                .frame(width: 98, height: 56)
                            Image(systemName: "xmark.circle").resizable().frame(width: 30, height: 30, alignment: .center)
                        }
                    }
                    Spacer()
                }.padding(.bottom, 30).foregroundColor(.black)
            }.navigationBarTitle("").navigationBarHidden(true)
        }
    }
}

struct StatusView_Previews: PreviewProvider {
    static var previews: some View {
        StatusView(viewModel: StatusViewModel())
    }
}
