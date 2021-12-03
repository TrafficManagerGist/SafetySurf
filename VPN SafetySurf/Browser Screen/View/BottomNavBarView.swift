import SwiftUI
struct BottomNavBarView: View {
    @ObservedObject var viewModel: WebViewModel
    @Environment(\.managedObjectContext) var managedObjectContext

    var body: some View {
        HStack {
            Spacer()
            ZStack {
                HStack {
                    Button(action:{
                        viewModel.webViewNavigationPublisher.send(.backward)
                    }) {
                        Image(systemName: "arrow.backward")
                            .font(.system(size:30))
                            .foregroundColor(Color.accentColor)
                            .padding(5)
                        
                    }
                    .padding(.leading, 5)
                    
                    Button(action:{
                        viewModel.webViewNavigationPublisher.send(.forward)
                    }) {
                        Image(systemName: "arrow.forward")
                            .font(.system(size:30))
                            .foregroundColor(Color.accentColor)
                            .padding(5)
                    }
                    .padding(5)
                    .padding(.vertical, 5)

                    Spacer()
                    
                }
                Spacer()
            }
            Spacer()
        }
    }
}
