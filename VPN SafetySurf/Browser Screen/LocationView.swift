//
//  LocationView.swift
//  VPN SafetySurf
//
//  Created by Алексей Трушковский on 29.11.2021.
//
import SwiftUI
struct LocationView: View {
    @ObservedObject var viewModel: LocationViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    init(viewModel: LocationViewModel) {
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
                    Text("Locations").font(.system(size: 30, weight: .semibold)).tracking(1).multilineTextAlignment(.center).foregroundColor(Color(hex: "fff"))
                    Spacer()
                }.padding(.top, 30)
                
                HStack {
//                    ForEach(identServers, id: \.id) { item in
//                        Button {
//                            viewModel.saveConfig(config: item)
//                        } label: {
//                            ZStack {
//                                RoundedRectangle(cornerRadius: 28)
//                                    .fill(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
//                                    .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.07999999821186066)), radius:24, x:0, y:16)
//                                HStack {
//                                    ImageView(withURL: item.imageLink).padding()
//                                    Text(item.location).font(.system(size: 20, weight: .semibold)).tracking(1).multilineTextAlignment(.center).foregroundColor(Color(hex: "000"))
//                                    Spacer()
//                                }
//                            }
//                        }
//                    }.padding()
                    
                    List(identServers, id: \.id) { item in
                        ZStack {
                            RoundedRectangle(cornerRadius: 28)
                                .fill(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
                                .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.07999999821186066)), radius:24, x:0, y:16)
                            HStack {
                                ImageView(withURL: item.imageLink).padding()
                                Text(item.location).font(.system(size: 20, weight: .semibold)).tracking(1).multilineTextAlignment(.center).foregroundColor(Color(hex: "000"))
                                Spacer()
                            }
                        }.onTapGesture {
                            viewModel.saveConfig(config: item)
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    }
                }.padding()
                HStack {
                    Spacer()
                    Button {
                        self.presentationMode.wrappedValue.dismiss()
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

struct LocationView_Previews: PreviewProvider {
    static var previews: some View {
        LocationView(viewModel: LocationViewModel(servers: [ServerIdentifiable(strength: 2, ping: 150, location: "location", imageLink: "imageLink", ip: "ip", username: "username", pass: "pass", serverID: "fef")]))
    }
}

struct ImageView: View {
    @ObservedObject var imageLoader:ImageLoader
    @State var image:UIImage = UIImage()
    @State private var opacity = 0.0

    init(withURL url:String) {
        imageLoader = ImageLoader(urlString:url)
    }
    
    var body: some View {
        
        Image(uiImage: image)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width:60, height:60)
            .opacity(opacity)
            .onReceive(imageLoader.didChange) { data in
                self.image = UIImage(data: data) ?? UIImage()
                withAnimation(.easeInOut(duration: 0.5), {
                    opacity = 1
                })
            }
    }
}
