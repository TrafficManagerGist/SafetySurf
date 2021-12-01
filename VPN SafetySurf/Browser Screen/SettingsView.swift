//
//  SettingsView.swift
//  VPN SafetySurf
//
//  Created by Алексей Трушковский on 29.11.2021.
//
import SwiftUI
import StoreKit

struct SettingsView: View {
    @ObservedObject var viewModel: SettingsViewModel
    @State private var isSharePresented: Bool = false
    
    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        UITableView.appearance().separatorColor = .clear
        UITableView.appearance().backgroundColor = .clear
        UITableViewCell.appearance().backgroundColor = .clear
        UITableViewCell.appearance().selectionStyle = .none
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color(hex: "5E5CE6"), Color(hex: "64D2FF")]), startPoint: .topLeading, endPoint: .bottomTrailing).edgesIgnoringSafeArea(.all)
            }
            ZStack {
                VStack {
                    
                    HStack {
                        Text("Settings").font(.system(size: 30, weight: .semibold)).tracking(1).multilineTextAlignment(.center).foregroundColor(Color(hex: "fff")).padding(.top, 30)
                    }
                    
                    HStack {
                        List(0..<5) { item in
                            Button {
                                switch item {
                                case 0:
                                    guard let url = URL(string: "https://pastebin.com/bEtu1d2i") else { return }
                                    UIApplication.shared.open(url)
                                case 1:
                                    guard let url = URL(string: "https://pastebin.com/100LQTfJ") else { return }
                                    UIApplication.shared.open(url)
                                case 2:
                                    guard let url = URL(string: "https://forms.gle/Ze8QzShZbzdQchV78") else { return }
                                    UIApplication.shared.open(url)
                                case 3:
                                    SKStoreReviewController.requestReview()
                                case 4:
                                    self.isSharePresented = true
                                default:
                                    print("Undefined")
                                }
                            } label: {
                                ZStack {
                                RoundedRectangle(cornerRadius: 28)
                                .fill(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
                                .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.07999999821186066)), radius:24, x:0, y:16)
                                    HStack {
                                        Image(systemName: viewModel.buttonsImages[item]).resizable().frame(width: 35, height: 35, alignment: .center)
                                            .padding().foregroundColor(Color(hex: "000"))
                                        Text(viewModel.buttonsNames[item]).font(.system(size: 20, weight: .semibold)).tracking(1).multilineTextAlignment(.center).foregroundColor(Color(hex: "000"))
                                        Spacer()
                                    }
                                }
                            }.listRowBackground(Color.clear)
                        }
                    }.sheet(isPresented: $isSharePresented, onDismiss: {
                        print("Dismiss")
                    }, content: {
                        ActivityViewController(activityItems: [URL(string: "https://apps.apple.com/us/app/safety-surf/id1595572217")!])
                    })
                }
            }
        }.edgesIgnoringSafeArea(.all)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SettingsView(viewModel: SettingsViewModel(presentedAsModal: true))
        }
    }
}

struct ActivityViewController: UIViewControllerRepresentable {

    var activityItems: [Any]
    var applicationActivities: [UIActivity]? = nil

    func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityViewController>) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ActivityViewController>) {}

}
