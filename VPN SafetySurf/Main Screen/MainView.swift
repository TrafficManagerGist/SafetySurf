//
//  MainView.swift
//  VPN SafetySurf
//
//  Created by Алексей Трушковский on 01.11.2021.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var viewModel: MainViewModel
    @State var isOpen = false
    @State private var isSharePresented: Bool = false
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color(hex: "5E5CE6"), Color(hex: "64D2FF")]), startPoint: .topLeading, endPoint: .bottomTrailing).edgesIgnoringSafeArea(.all)
            }.present($viewModel.activatePrivacyScreen, view: PrivacyView(isPrivacyPresented: $viewModel.activatePrivacyScreen))
            ZStack {
                VStack {
                    TopShape().foregroundColor(Color(hex: "F3F5F7")).frame(height: geometry.size.height/2.5).edgesIgnoringSafeArea(.all).padding(.bottom, 0)
                    Spacer()
                    BottomShape().foregroundColor(Color(hex: "F3F5F7")).frame(height: geometry.size.height/1.5).edgesIgnoringSafeArea(.all).padding(.bottom, 0)
                }
            }
            ZStack {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        
                            Button {
                                print("Connect")
                            } label: {
                                ZStack {
                                StartShape().frame(width: geometry.size.width/2, height: geometry.size.width/2)    .foregroundColor(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
                                    .frame(width: 99, height: 99)
                                    .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.07999999821186066)), radius:24, x:0, y:16)
                                Text("START").font(.custom("Antonio Light", size: 30)).tracking(1).multilineTextAlignment(.center).gradientForeground(colors: [Color(hex: "64D2FF"), Color(hex: "5E5CE6")])
                            }
                        }
                        
                        //Start
                        
                        Spacer()
                    }
                    Spacer(minLength: geometry.size.height/2.5)
                    HStack {
                        VStack {
                            Text("Last locations").font(.custom("Antonio Light", size: 15)).tracking(1).multilineTextAlignment(.center).foregroundColor(Color(hex: "7C858D"))
                            
                            ForEach(0 ..< 100) {
                                    Text("Row \($0)")
                                }
                        }
                    }
                    HStack {
                        Spacer()
                        VStack {
                            Image("optimalIcon").resizable().frame(width: 20, height: 30, alignment: .center)
                            Text("Auto").font(.custom("Antonio Light", size: 15)).tracking(1).multilineTextAlignment(.center).foregroundColor(Color(hex: "7C858D"))
                        }
                        Spacer()
                        VStack {
                            Text("UNITED STATES").font(.custom("Antonio Light", size: 15)).tracking(1).multilineTextAlignment(.center).foregroundColor(Color(hex: "000"))
                            Text("5.149.112.247").font(.custom("Antonio Light", size: 15)).tracking(1).multilineTextAlignment(.center).foregroundColor(Color(hex: "7C858D"))
                        }
                        Spacer()
                        VStack {
                            HStack {
                                Circle().fill().foregroundColor(Color(hex: "32D74B")).frame(width: 10, height: 10, alignment: .center)
                                Circle().fill().foregroundColor(Color(hex: "32D74B")).frame(width: 10, height: 10, alignment: .center)
                                Circle().fill().foregroundColor(Color(hex: "32D74B")).frame(width: 10, height: 10, alignment: .center)
                            }
                            Text("26 ms").font(.custom("Antonio Light", size: 15)).tracking(1).multilineTextAlignment(.center).foregroundColor(Color(hex: "7C858D"))
                        }
                        Spacer()
                    }.padding(20)
                    HStack {
                        Spacer()
                        Button {
                            print("Connect")
                        } label: {
                            ZStack {
                            RoundedRectangle(cornerRadius: 28)
                            .fill(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
                            .frame(width: 98, height: 56).shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.07999999821186066)), radius:24, x:0, y:16)
                                Image("locationIcon").resizable().frame(width: 30, height: 30, alignment: .center)
                            }
                        }
                        Spacer()
                        Button {
                            print("Connect")
                        } label: {
                            ZStack {
                            RoundedRectangle(cornerRadius: 28)
                            .fill(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
                                .frame(width: 98, height: 56).shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.07999999821186066)), radius:24, x:0, y:16)
                                Image("settingsIcon").resizable().frame(width: 30, height: 30, alignment: .center)
                            }
                        }
                        Spacer()
                    }.padding(.bottom, 50)
                }
            }
        }.edgesIgnoringSafeArea(.all)
    }
}

struct MyCustomShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.addRect(CGRect(x: 0, y: 0, width: width, height: height))
        path.move(to: CGPoint(x: 0.61735*width, y: 0.60565*height))
        path.addLine(to: CGPoint(x: 0.61735*width, y: 0.39435*height))
        path.addCurve(to: CGPoint(x: 0.61596*width, y: 0.38535*height), control1: CGPoint(x: 0.61735*width, y: 0.39119*height), control2: CGPoint(x: 0.61687*width, y: 0.38808*height))
        path.addCurve(to: CGPoint(x: 0.61216*width, y: 0.3788*height), control1: CGPoint(x: 0.61504*width, y: 0.38262*height), control2: CGPoint(x: 0.61374*width, y: 0.38036*height))
        path.addLine(to: CGPoint(x: 0.50502*width, y: 0.27282*height))
        path.addCurve(to: CGPoint(x: 0.5*width, y: 0.27051*height), control1: CGPoint(x: 0.50349*width, y: 0.27131*height), control2: CGPoint(x: 0.50176*width, y: 0.27051*height))
        path.addCurve(to: CGPoint(x: 0.49498*width, y: 0.27282*height), control1: CGPoint(x: 0.49824*width, y: 0.27051*height), control2: CGPoint(x: 0.49651*width, y: 0.27131*height))
        path.addLine(to: CGPoint(x: 0.38783*width, y: 0.3788*height))
        path.addCurve(to: CGPoint(x: 0.38404*width, y: 0.38535*height), control1: CGPoint(x: 0.38626*width, y: 0.38036*height), control2: CGPoint(x: 0.38495*width, y: 0.38262*height))
        path.addCurve(to: CGPoint(x: 0.38265*width, y: 0.39435*height), control1: CGPoint(x: 0.38313*width, y: 0.38808*height), control2: CGPoint(x: 0.38265*width, y: 0.39119*height))
        path.addLine(to: CGPoint(x: 0.38265*width, y: 0.60565*height))
        path.addCurve(to: CGPoint(x: 0.38404*width, y: 0.61465*height), control1: CGPoint(x: 0.38265*width, y: 0.60881*height), control2: CGPoint(x: 0.38313*width, y: 0.61192*height))
        path.addCurve(to: CGPoint(x: 0.38783*width, y: 0.6212*height), control1: CGPoint(x: 0.38495*width, y: 0.61738*height), control2: CGPoint(x: 0.38626*width, y: 0.61964*height))
        path.addLine(to: CGPoint(x: 0.49498*width, y: 0.72718*height))
        path.addCurve(to: CGPoint(x: 0.5*width, y: 0.72949*height), control1: CGPoint(x: 0.49651*width, y: 0.72869*height), control2: CGPoint(x: 0.49824*width, y: 0.72949*height))
        path.addCurve(to: CGPoint(x: 0.50502*width, y: 0.72718*height), control1: CGPoint(x: 0.50176*width, y: 0.72949*height), control2: CGPoint(x: 0.50349*width, y: 0.72869*height))
        path.addLine(to: CGPoint(x: 0.61216*width, y: 0.6212*height))
        path.addCurve(to: CGPoint(x: 0.61596*width, y: 0.61465*height), control1: CGPoint(x: 0.61374*width, y: 0.61964*height), control2: CGPoint(x: 0.61504*width, y: 0.61738*height))
        path.addCurve(to: CGPoint(x: 0.61735*width, y: 0.60565*height), control1: CGPoint(x: 0.61687*width, y: 0.61192*height), control2: CGPoint(x: 0.61735*width, y: 0.60881*height))
        path.addLine(to: CGPoint(x: 0.61735*width, y: 0.60565*height))
        path.closeSubpath()
        path.move(to: CGPoint(x: 0.5*width, y: 0.58036*height))
        path.addCurve(to: CGPoint(x: 0.54592*width, y: 0.5*height), control1: CGPoint(x: 0.52536*width, y: 0.58036*height), control2: CGPoint(x: 0.54592*width, y: 0.54438*height))
        path.addCurve(to: CGPoint(x: 0.5*width, y: 0.41964*height), control1: CGPoint(x: 0.54592*width, y: 0.45562*height), control2: CGPoint(x: 0.52536*width, y: 0.41964*height))
        path.addCurve(to: CGPoint(x: 0.45408*width, y: 0.5*height), control1: CGPoint(x: 0.47464*width, y: 0.41964*height), control2: CGPoint(x: 0.45408*width, y: 0.45562*height))
        path.addCurve(to: CGPoint(x: 0.5*width, y: 0.58036*height), control1: CGPoint(x: 0.45408*width, y: 0.54438*height), control2: CGPoint(x: 0.47464*width, y: 0.58036*height))
        path.closeSubpath()
        return path
    }
}

struct StartShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.addEllipse(in: CGRect(x: 0.01515*width, y: 0.01515*height, width: 0.9697*width, height: 0.9697*height))
        return path
    }
}

struct BottomShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.move(to: CGPoint(x: 0, y: 0.12373*height))
        path.addCurve(to: CGPoint(x: width, y: 0.12373*height), control1: CGPoint(x: 0.36267*width, y: -0.04158*height), control2: CGPoint(x: 0.66533*width, y: -0.03651*height))
        path.addLine(to: CGPoint(x: width, y: height))
        path.addLine(to: CGPoint(x: 0, y: height))
        path.addLine(to: CGPoint(x: 0, y: 0.12373*height))
        path.closeSubpath()
        return path
    }
}

struct TopShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: width, y: 0))
        path.addLine(to: CGPoint(x: width, y: 0.82716*height))
        path.addCurve(to: CGPoint(x: 0, y: 0.82716*height), control1: CGPoint(x: 0.67467*width, y: 1.06944*height), control2: CGPoint(x: 0.28533*width, y: 1.04475*height))
        path.addLine(to: CGPoint(x: 0, y: 0))
        path.closeSubpath()
        return path
    }
}

struct SettingsShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.move(to: CGPoint(x: 0.85937*width, y: 0.68489*height))
        path.addLine(to: CGPoint(x: 0.85937*width, y: 0.31511*height))
        path.addCurve(to: CGPoint(x: 0.85511*width, y: 0.29936*height), control1: CGPoint(x: 0.85937*width, y: 0.30957*height), control2: CGPoint(x: 0.8579*width, y: 0.30414*height))
        path.addCurve(to: CGPoint(x: 0.8435*width, y: 0.2879*height), control1: CGPoint(x: 0.85232*width, y: 0.29458*height), control2: CGPoint(x: 0.84832*width, y: 0.29063*height))
        path.addLine(to: CGPoint(x: 0.51537*width, y: 0.10244*height))
        path.addCurve(to: CGPoint(x: 0.5*width, y: 0.0984*height), control1: CGPoint(x: 0.51068*width, y: 0.09979*height), control2: CGPoint(x: 0.50538*width, y: 0.0984*height))
        path.addCurve(to: CGPoint(x: 0.48462*width, y: 0.10244*height), control1: CGPoint(x: 0.49461*width, y: 0.0984*height), control2: CGPoint(x: 0.48931*width, y: 0.09979*height))
        path.addLine(to: CGPoint(x: 0.15649*width, y: 0.2879*height))
        path.addCurve(to: CGPoint(x: 0.14488*width, y: 0.29936*height), control1: CGPoint(x: 0.15168*width, y: 0.29063*height), control2: CGPoint(x: 0.14767*width, y: 0.29458*height))
        path.addCurve(to: CGPoint(x: 0.14062*width, y: 0.31511*height), control1: CGPoint(x: 0.14209*width, y: 0.30414*height), control2: CGPoint(x: 0.14062*width, y: 0.30957*height))
        path.addLine(to: CGPoint(x: 0.14062*width, y: 0.68489*height))
        path.addCurve(to: CGPoint(x: 0.14488*width, y: 0.70064*height), control1: CGPoint(x: 0.14062*width, y: 0.69042*height), control2: CGPoint(x: 0.14209*width, y: 0.69586*height))
        path.addCurve(to: CGPoint(x: 0.15649*width, y: 0.7121*height), control1: CGPoint(x: 0.14767*width, y: 0.70542*height), control2: CGPoint(x: 0.15168*width, y: 0.70937*height))
        path.addLine(to: CGPoint(x: 0.48462*width, y: 0.89756*height))
        path.addCurve(to: CGPoint(x: 0.5*width, y: 0.9016*height), control1: CGPoint(x: 0.48931*width, y: 0.90021*height), control2: CGPoint(x: 0.49461*width, y: 0.9016*height))
        path.addCurve(to: CGPoint(x: 0.51537*width, y: 0.89756*height), control1: CGPoint(x: 0.50538*width, y: 0.9016*height), control2: CGPoint(x: 0.51068*width, y: 0.90021*height))
        path.addLine(to: CGPoint(x: 0.8435*width, y: 0.7121*height))
        path.addCurve(to: CGPoint(x: 0.85511*width, y: 0.70064*height), control1: CGPoint(x: 0.84832*width, y: 0.70937*height), control2: CGPoint(x: 0.85232*width, y: 0.70542*height))
        path.addCurve(to: CGPoint(x: 0.85937*width, y: 0.68489*height), control1: CGPoint(x: 0.8579*width, y: 0.69586*height), control2: CGPoint(x: 0.85937*width, y: 0.69042*height))
        path.addLine(to: CGPoint(x: 0.85937*width, y: 0.68489*height))
        path.closeSubpath()
        path.move(to: CGPoint(x: 0.5*width, y: 0.64063*height))
        path.addCurve(to: CGPoint(x: 0.64062*width, y: 0.5*height), control1: CGPoint(x: 0.57766*width, y: 0.64063*height), control2: CGPoint(x: 0.64062*width, y: 0.57767*height))
        path.addCurve(to: CGPoint(x: 0.5*width, y: 0.35938*height), control1: CGPoint(x: 0.64062*width, y: 0.42233*height), control2: CGPoint(x: 0.57766*width, y: 0.35938*height))
        path.addCurve(to: CGPoint(x: 0.35937*width, y: 0.5*height), control1: CGPoint(x: 0.42233*width, y: 0.35938*height), control2: CGPoint(x: 0.35937*width, y: 0.42233*height))
        path.addCurve(to: CGPoint(x: 0.5*width, y: 0.64063*height), control1: CGPoint(x: 0.35937*width, y: 0.57767*height), control2: CGPoint(x: 0.42233*width, y: 0.64063*height))
        path.closeSubpath()
        return path
    }
}

struct ImageView: View {
    @ObservedObject var imageLoader:ImageLoader
    @State var image:UIImage = UIImage()

    init(url:String) {
        imageLoader = ImageLoader(urlString:url)
    }

    var body: some View {
        
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width:100, height:100)
                .onReceive(imageLoader.didChange) { data in
                self.image = UIImage(data: data) ?? UIImage()
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MainView(viewModel: MainViewModel())
        }
    }
}
