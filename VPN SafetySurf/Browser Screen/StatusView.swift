//
//  StatusView.swift
//  VPN SafetySurf
//
//  Created by Алексей Трушковский on 29.11.2021.
//

import SwiftUI
import Charts

struct StatusView: View {
    @ObservedObject var viewModel: StatusViewModel
    @State var presentingModal = false
    
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
                
                VStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 30)
                            .fill(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.3)))
                        VStack {
                            Text("Download Speed").font(.system(size: 20, weight: .semibold)).tracking(1).multilineTextAlignment(.center).foregroundColor(Color(hex: "fff"))
                            Chart(data: viewModel.downloadArray)
                                .chartStyle(
                                    LineChartStyle(.quadCurve, lineColor: .white, lineWidth: 5)
                                )
                            Text(viewModel.downloadLabel).font(.system(size: 20, weight: .semibold)).tracking(1).multilineTextAlignment(.center).foregroundColor(Color(hex: "fff"))
                        }.padding()
                    }.padding()
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.3)))
                        VStack {
                            Text("Upload Speed").font(.system(size: 20, weight: .semibold)).tracking(1).multilineTextAlignment(.center).foregroundColor(Color(hex: "fff"))
                            Chart(data: viewModel.uploadArray)
                                .chartStyle(
                                    LineChartStyle(.quadCurve, lineColor: .white, lineWidth: 5)
                                )
                            Text(viewModel.uploadLabel).font(.system(size: 20, weight: .semibold)).tracking(1).multilineTextAlignment(.center).foregroundColor(Color(hex: "fff"))
                        }.padding()
                    }.padding()
                }.padding()
                
                HStack {
                    Text(viewModel.timeLabel).font(.system(size: 30, weight: .semibold)).tracking(1).multilineTextAlignment(.center).foregroundColor(Color(hex: "fff"))
                }
                HStack {
                    Spacer()
                    Button {
                        VPNLogic().disconnectVPN()
                        viewModel.stopSpeedTest()
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 28)
                                .fill(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
                                .frame(width: 150, height: 60)
                            Text("Disconnect").font(.system(size: 20, weight: .semibold)).tracking(1).multilineTextAlignment(.center).foregroundColor(Color(hex: "000"))
                        }
                    }
                    
                    Spacer()
                    
                    Button {
                        self.presentingModal = true
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 28)
                                .fill(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
                                .frame(width: 150, height: 60)
                            Text("Browser").font(.system(size: 20, weight: .semibold)).tracking(1).multilineTextAlignment(.center).foregroundColor(Color(hex: "000"))
                        }
                    }
                    
                    Spacer()
                }.padding(.bottom, 30).foregroundColor(.black).sheet(isPresented: $presentingModal) { BrowserPage() }
            }.navigationBarTitle("").navigationBarHidden(true)
        }
    }
}

struct StatusView_Previews: PreviewProvider {
    static var previews: some View {
        StatusView(viewModel: StatusViewModel())
    }
}
