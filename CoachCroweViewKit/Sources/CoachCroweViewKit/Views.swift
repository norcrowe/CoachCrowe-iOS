import Foundation
import SwiftUI
import CoachCroweBasic
import AnimateText

/// 旋转App Logo
public struct RotatingCoachCrowe: View {
    public var height: CGFloat
    @State private var randomRotation: RandomRotationEffectModel = RandomRotationEffectModel()
    @State private var isRotating: Bool = true
    
    public init(height: CGFloat) {
        self.height = height
    }
    
    /// body
    public var body: some View {
        Image("coachcrowe")
            .resizable()
            .frame(width: height, height: height)
            .clipShape(RoundedRectangle(cornerRadius: 0.35*height, style: .continuous))
            .shadow(color: Color(randomRotation.shadowColor).opacity(0.3), radius: 10, x: 0, y: 2)
            .rotation3DEffect(Angle(degrees: randomRotation.degrees), axis: (x: randomRotation.x, y: randomRotation.y, z: randomRotation.z))
            .onAppear {
                /// 使用计时器定期更改
                let timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                    withAnimation(.easeInOut(duration: 1)) {
                        if isRotating {
                            randomRotation = .init()
                        }
                    }
                }
                timer.fire()
            }
            .onTapGesture {
                withAnimation(.spring) {
                    isRotating.toggle()
                }
            }
    }
    
    /// 模型
    struct RandomRotationEffectModel {
        var degrees: CGFloat
        var x: CGFloat
        var y: CGFloat
        var z: CGFloat
        var shadowColor: RGBAModel
        
        init(degrees: CGFloat = CGFloat.random(in: -10...10), x: CGFloat = CGFloat.random(in: 0...1), y: CGFloat = CGFloat.random(in: 0...1), z: CGFloat = CGFloat.random(in: 0...1), shadowColor: RGBAModel = RGBAModel(red: Double.random(in: 0...255), green: Double.random(in: 0...255), blue: Double.random(in: 0...255), alpha: 255)) {
            self.degrees = degrees
            self.x = x
            self.y = y
            self.z = z
            self.shadowColor = shadowColor
        }
    }

}

/// 加载动画 - 塞尔达传说
public struct Zelda: View {
    @State private var first: CGFloat = 1
    @State private var second: CGFloat = 0.6
    @State private var size: CGFloat = 7.5
    
    public init() {}
    
    /// body
    public var body: some View {
        VStack(spacing: size*2) {
            AnimatedCircles(first: first, second: second)

            AnimatedCircles(first: second, second: first)
                .rotationEffect(.degrees(180))
        }
        .shadow(color: Color(ColorSelection.primary), radius: 10)
        .onAppear {
            let timer = Timer.scheduledTimer(withTimeInterval: 0.4, repeats: true) { _ in
                withAnimation(.snappy) {
                    self.first = self.first != 1 ? 1 : 0.6
                    self.second = self.second != 1 ? 1 : 0.6
                }
            }
            timer.fire()
        }
    }
    
    /// 动态圆圈
    private struct AnimatedCircles: View {
        private let size: CGFloat = 7.5
        var first: CGFloat
        var second: CGFloat
        
        init(first: CGFloat, second: CGFloat) {
            self.first = first
            self.second = second
        }
        
        //MARK: View
        var body: some View {
            ZStack {
                Circle()
                    .frame(width: size, height: size)
                    .foregroundColor(Color(ColorSelection.primary))
                    .scaleEffect(second)

                HStack(spacing: size*2) {
                    Circle()
                        .frame(width: size, height: size)
                    Circle()
                        .frame(width: size, height: size)
                }
                .foregroundColor(Color(ColorSelection.primary))
                .scaleEffect(first)
                .offset(y: size*0.75)
            }
        }
    }

}

/// ErrorView
public struct ErrorView: View {
    var text: String
    let action: () -> Void
    
    public init(text: String, action: @escaping () -> Void) {
        self.text = text
        self.action = action
    }
    
    /// body
    public var body: some View {
        VStack(spacing: 10) {
            Spacer()
            Image(systemName: "xmark.circle")
                .font(.system(size: 52))
                .foregroundColor(.red)
            Text(text)
                .font(.title3.bold())
                .foregroundColor(Color(ColorSelection.gray))
            Spacer()
            RoundedFillColorNextStepButton(text: "Try again") {
                action()
            }
        }
        .frame(width: MemberSizes.componentWidth)
        .fullBackgroundColor()
    }
}

/// RegionPicker
public struct RegionPicker: View {
    @Binding var region: Region
    @Binding var show: Bool
    let regions: [Region] = [.china, .portugal]
    
    public init(region: Binding<Region>, show: Binding<Bool>) {
        _region = region
        _show = show
    }
    
    /// body
    public var body: some View {
        NavigationView {
            List {
                ForEach(regions, id: \.self) { region in
                    Button {
                        withAnimation(.spring) {
                            self.region = region
                            self.show = false
                        }
                    } label: {
                        HStack {
                            Text(region.flag + region.name)
                                .foregroundColor(Color(ColorSelection.primary))
                            Spacer()
                            Text(region.number)
                                .foregroundStyle(Color(ColorSelection.primary))
                                .padding(.vertical, 5)
                                .padding(.horizontal, 10)
                                .roundedColorBackground(color: .green, radius: 10, opacity: region.number == self.region.number ? 1 : 0)
                        }
                    }
                }
                .listRowBackground(Color(ColorSelection.secondary))
            }
            .navigationTitle(NSLocalizedString("Pick Your Region Number", comment: ""))
            .navigationBarItems(trailing:
                Button {
                    show = false
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 14).bold())
                        .foregroundColor(Color(.primary))
                        .frame(width: 35, height: 35)
                        .roundedColorBackground(color: Color(ColorSelection.secondary), radius: 99)
                }
            )

        }


    }
}

/// HudView
struct HudView: View {
    @Binding var hudState: HudState?
    private var messageWidth: CGFloat {
        let bodyFontSize = UIFont.preferredFont(forTextStyle: .body).pointSize
        switch hudState {
        case .progress:
            return 105
        case .completed(_, let message):
            let messageWidth = message.size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: bodyFontSize)]).width
            return messageWidth > 105 ? messageWidth : 105
        case nil:
            return 105
        }
    }
    private var fullWidth: CGFloat {
        return messageWidth + 70
    }
    
    init(hudState: Binding<HudState?>) {
        _hudState = hudState
    }
    
    /// body
    var body: some View {
        ZStack {
            switch hudState {
            case .progress:
                Zelda()
            case .completed(let completedState, let message):
                ZStack {
                    Image(systemName: completedState == HudState.CompletedState.successed ? "checkmark" : "exclamationmark.circle")
                        .font(.title3.bold())
                        .hAlign(.leading)
                        .padding(.leading, 15)
                    Text(key: message)
                        .font(.body.bold())
                        .frame(width: messageWidth)
                }
                .foregroundColor(Color(ColorSelection.gray))
                .frame(width: fullWidth, height: 50)
                .roundedColorBackground(color: .white, radius: 999)
                .transition(.asymmetric(insertion: .move(edge: .top), removal: .move(edge: .top)))
                .vAlign(.top)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                        withAnimation(.spring){
                            hudState = nil
                        }
                    }
                }
            case .none:
                EmptyView()
            }
        }
        .background(
            Color.black
                .opacity(hudState == nil ? 0 : 0.3)
                .frame(width: MemberSizes.screenWidth, height: MemberSizes.screenHeight)
                .ignoresSafeArea(.all)
        )
    }
}
