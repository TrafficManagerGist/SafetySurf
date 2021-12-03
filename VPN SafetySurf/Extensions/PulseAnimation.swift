import SwiftUI

// MARK: - Strucutre for Circle
struct CircleData: Hashable {
    let width: CGFloat
    let opacity: Double
}

struct PJRPulseButton: View {
    
    // MARK: - Properties
    var color: Color
    var systemImageName: String
    var buttonWidth: CGFloat
    var numberOfOuterCircles: Int
    var animationDuration: Double
    var circleArray = [CircleData]()
    @ObservedObject var viewModel: MainViewModel


    init(color: Color = Color.blue, systemImageName: String = "plus.circle.fill",  buttonWidth: CGFloat = 48, numberOfOuterCircles: Int = 2, animationDuration: Double  = 1, viewModel: MainViewModel) {
        self.color = color
        self.systemImageName = systemImageName
        self.buttonWidth = buttonWidth
        self.numberOfOuterCircles = numberOfOuterCircles
        self.animationDuration = animationDuration
        self.viewModel = viewModel
        
        var circleWidth = self.buttonWidth
        var opacity = (numberOfOuterCircles > 4) ? 0.40 : 0.20
        
        for _ in 0..<numberOfOuterCircles{
            circleWidth += 20
            self.circleArray.append(CircleData(width: circleWidth, opacity: opacity))
            opacity -= 0.05
        }
        
    }

    // MARK: - Body
    var body: some View {
        ZStack {
            Group {
                ForEach(circleArray, id: \.self) { cirlce in
                    Circle()
                            .fill(self.color)
                        .opacity(viewModel.isAnimating ? cirlce.opacity : 0)
                        .frame(width: cirlce.width, height: cirlce.width, alignment: .center)
                        .scaleEffect(viewModel.isAnimating ? 1 : 0)
                }
                
            }.animation(Animation.easeInOut(duration: animationDuration).repeatForever(autoreverses: true),
               value: viewModel.isAnimating)

            Button(action: {
                viewModel.vpnButtonPressed()
            }) {
                ZStack {
                    StartShape().frame(width: self.buttonWidth, height: self.buttonWidth)    .foregroundColor(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
                        .frame(width: self.buttonWidth, height: self.buttonWidth)
                        .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.07999999821186066)), radius:24, x:0, y:16)
                    Text(viewModel.status).font(.custom("Antonio Light", size: 30)).tracking(1).multilineTextAlignment(.center).gradientForeground(colors: [Color(hex: "64D2FF"), Color(hex: "5E5CE6")])
                }
            }
        }
    }

}

// MARK: - Preview
struct PulseButton_Previews: PreviewProvider {
    static var previews: some View {
        PJRPulseButton(viewModel: MainViewModel())
    }
}
