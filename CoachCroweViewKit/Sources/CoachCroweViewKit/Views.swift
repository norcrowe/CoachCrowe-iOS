import Foundation
import SwiftUI
import CoachCroweBasic
import CoachCroweViewModels

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
        .shadow(color: Color(ColorSelection.primaryColor), radius: 10)
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
                    .colored(.primaryColor)
                    .scaleEffect(second)

                HStack(spacing: size*2) {
                    Circle()
                        .frame(width: size, height: size)
                    Circle()
                        .frame(width: size, height: size)
                }
                .colored(.primaryColor)
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
                .colored(.gray)
            Spacer()
            RoundedFillColorNextStepButton(text: "Try again") {
                action()
            }
        }
        .frame(width: MemberSizes.componentWidth)
        .fullBackgroundColor()
    }
}

/// HudView
struct HudView: View {
    @Binding var hudState: HudState?
    @State private var isPresented: Bool = false
    
    init(hudState: Binding<HudState?>) {
        _hudState = hudState
    }
    
    /// body
    var body: some View {
        ZStack {
            switch hudState {
            case .progress:
                ProgressView()
            case .completed(let completedState, let title, let action):
                Color.clear
                    .alert(isPresented: $isPresented) {
                        let messageText = completedState == .successed ? nil : Text(key: "Please try again")
                        return Alert(title: Text(title), message: messageText, dismissButton: .default(Text("Done"), action: {
                            withAnimation(.spring) {
                                isPresented = false
                                hudState = nil
                                if let action {
                                    action()
                                }
                            }
                        }))
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
        .onChange(of: hudState) { newState in
            switch newState {
            case .completed:
                isPresented = true
            case .progress, .none:
                break
            }
        }
        .animation(.spring, value: hudState)
    }
}

/// 主视图Head Bar
struct MainViewHeadBar<Content: View>: View {
    let title: String
    @Binding var showSideBar: Bool
    let content: () -> Content
    
    init(title: String, showSideBar: Binding<Bool>, content: @escaping () -> Content) {
        self.title = title
        _showSideBar = showSideBar
        self.content = content
    }
    
    /// body
    var body: some View {
        VStack(spacing: 5) {
            SideBarButton(showSideBar: $showSideBar)
            .hAlign(.leading)
            HStack {
                Text(title)
                    .font(.title.bold())
                    .colored(.primaryColor)
                Spacer()
                content()
            }
        }
        .frame(width: MemberSizes.effectiveWidth, height: MemberSizes.safeAreaInsets.top + MemberSizes.mainViewHeadBarHeight, alignment: .bottom)
    }
}

/// Side Bar
public struct SideBar: View {
    @Binding var currentSelection: MainViewState
    @State private var showSharedSelection: Bool = false
    
    public init(currentSelection: Binding<MainViewState>) {
        _currentSelection = currentSelection
    }
    
    /// body
    public var body: some View {
        VStack(spacing: 15) {
            Spacer()
                .frame(height: MemberSizes.mainViewHeadBarHeight-MemberSizes.controlSecondaryHeight)
            
            HStack(spacing: 5) {
                RotatingCoachCrowe(height: MemberSizes.controlHeight)
                Text(key: "Coach Crowe")
                    .font(.title2.bold())
            }
                .hAlign(.leading)
            
            VStack(spacing: 5) {
                selections()
                
                sharedSelection()
            }
            Spacer()
        }
        .padding(.horizontal, 10)
        .frame(width: MemberSizes.sideBarWidth, height: MemberSizes.screenHeight)
        .backgroundColor(Color(ColorSelection.backgroundColor))
    }
    
    @ViewBuilder
    func selections() -> some View {
        VStack(spacing: 5) {
            ForEach(MainViewState.allCases, id: \.self) { selection in
                let currented = selection == currentSelection
                let sFSymbolName = currented ? selection.sFSymbolName + ".fill" : selection.sFSymbolName
                
                Button {
                    currentSelection = selection
                } label: {
                    HStack(spacing: 0) {
                        Image(systemName: sFSymbolName)
                            .frame(maxWidth: 40)
                        Text(key: selection.description)
                    }
                    .foregroundColor(currented ? .white : .black)
                    .font(.title2)
                    .frame(height: MemberSizes.controlHeight)
                    .hAlign(.leading)
                    .roundedColorBackground(color: .blue, radius: 10, opacity: currented ? 1 : 0)
                }
            }
        }
        
    }
    
    func sharedSelection() -> some View {
        VStack(alignment: .leading, spacing: 2.5) {
            Button {
                let duration: CGFloat = showSharedSelection ? 0.2 : 0.5
                withAnimation(.spring(duration: duration)) {
                    showSharedSelection.toggle()
                }
            } label: {
                HStack {
                    HStack(spacing: 0) {
                        Image(systemName: "link")
                            .frame(maxWidth: 40)
                        Text(key: "Shared")
                    }
                    .foregroundColor(.black)
                    .font(.title2)
                    .frame(height: MemberSizes.controlHeight)
                    
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.body)
                        .colored(.gray)
                        .rotationEffect(Angle(degrees: showSharedSelection ? 90 : 0))
                }
            }
            

            Button {
            } label: {
                HStack(spacing: 0) {
                    Circle()
                        .strokeBorder(.white, lineWidth: 1)
                        .frame(width: 15, height: 15)
                        .background(
                            Circle()
                                .foregroundColor(.blue)
                        )
                        .frame(maxWidth: 40)
                    Text(key: "共享的战术板")
                        .font(.title2)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.black)
                }
                .frame(height: MemberSizes.controlHeight)
                .hAlign(.leading)
                .opacity(showSharedSelection ? 1 : 0)
                .offset(y: showSharedSelection ? 0 : -10)
            }
                
        }
    }
}

/// 篮球球场视图集
public class BasketballFieldViews {
    /// 四分之一的篮球场
    struct QuarterBasketballField: View {
        @ObservedObject var basketballFieldViewModel: BasketballFieldViewModel
        
        init(basketballFieldViewModel: BasketballFieldViewModel) {
            self.basketballFieldViewModel = basketballFieldViewModel
        }
        
        /// body
        var body: some View {
            ZStack {
                /// 底板颜色
                Color(basketballFieldViewModel.colorsData.interiorFillColor)
                
                /// 掷球线
                PathsAndShapes.CustomHorLinePath(startingX: 0, endX: 0.15*basketballFieldViewModel.quarterFieldWidth, y: basketballFieldViewModel.passingLineY)
                    .stroke(Color(basketballFieldViewModel.colorsData.mainLinesColor), lineWidth: basketballFieldViewModel.mainLinesWidth)
                
                /// 三分线
                Group {
                    PathsAndShapes.HalfThreePointLine(threePointLineStartingX: basketballFieldViewModel.threePointLineStartingX, threePointLineVerticalY: basketballFieldViewModel.threePointLineVerticalY, threePointLineBottomCornerY: basketballFieldViewModel.threePointLineBottomCornerY, threePointLineCurveControlX: basketballFieldViewModel.threePointLineCurveControlX, filled: true)
                        .foregroundColor(Color(basketballFieldViewModel.colorsData.threePointLineInteriontFillColor))
                    PathsAndShapes.HalfThreePointLine(threePointLineStartingX: basketballFieldViewModel.threePointLineStartingX, threePointLineVerticalY: basketballFieldViewModel.threePointLineVerticalY, threePointLineBottomCornerY: basketballFieldViewModel.threePointLineBottomCornerY, threePointLineCurveControlX: basketballFieldViewModel.threePointLineCurveControlX)
                        .stroke(Color(basketballFieldViewModel.colorsData.mainLinesColor), lineWidth: basketballFieldViewModel.mainLinesWidth)
                }
                            
                /// 内线
                Group {
                    PathsAndShapes.HalfInteriorLine(interiorLineStartingX: basketballFieldViewModel.interiorLineStartingX, interiorLineVerticalY: basketballFieldViewModel.interiorLineVerticalY, filled: true)
                        .foregroundColor(Color(basketballFieldViewModel.colorsData.interiorLineFillColor))
                    PathsAndShapes.HalfInteriorLineWithPlayerPositionLine(interiorLineStartingX: basketballFieldViewModel.interiorLineStartingX, interiorLineVerticalY: basketballFieldViewModel.interiorLineVerticalY, lineWidth: basketballFieldViewModel.mainLinesWidth, width: basketballFieldViewModel.quarterFieldWidth, lineColor: Color(basketballFieldViewModel.colorsData.mainLinesColor))
                }

                /// 罚球圈
                PathsAndShapes.HalfFreeThrowCircle(radius: basketballFieldViewModel.freeThrowCircleRadius, centerPoint: CGPoint(x: basketballFieldViewModel.quarterFieldWidth, y: basketballFieldViewModel.interiorLineVerticalY))
                    .stroke(Color(basketballFieldViewModel.colorsData.mainLinesColor), lineWidth: basketballFieldViewModel.mainLinesWidth)
                    .offset(y: basketballFieldViewModel.mainLinesWidth/2)
                
                /// 三秒区
                PathsAndShapes.HalfThreePointLine(threePointLineStartingX: basketballFieldViewModel.threeSecondZoneLineStartingX, threePointLineStartingY: basketballFieldViewModel.reboundY, threePointLineVerticalY: basketballFieldViewModel.threeSecondZoneLineVerticalY, threePointLineBottomCornerY: basketballFieldViewModel.reboundY, threePointLineCurveControlX: basketballFieldViewModel.threeSecondZoneLineStartingX)
                    .stroke(Color(basketballFieldViewModel.colorsData.mainLinesColor), lineWidth: basketballFieldViewModel.mainLinesWidth)
                
                /// 篮筐和篮板
                Group {
                    PathsAndShapes.CustomHorLinePath(startingX: basketballFieldViewModel.reboundX, endX: basketballFieldViewModel.quarterFieldWidth, y: basketballFieldViewModel.reboundY)
                        .stroke(Color(basketballFieldViewModel.colorsData.mainLinesColor), lineWidth: basketballFieldViewModel.mainLinesWidth)
                    PathsAndShapes.CustomCircle(center: CGPoint(x: basketballFieldViewModel.quarterFieldWidth, y: basketballFieldViewModel.reboundY + basketballFieldViewModel.basketRadius), radius: basketballFieldViewModel.basketRadius, startAngle: -90, endAngle: 90)
                        .stroke(Color(basketballFieldViewModel.colorsData.mainLinesColor), lineWidth: basketballFieldViewModel.mainLinesWidth)
                }
            }
            .frame(width: basketballFieldViewModel.quarterFieldWidth, height: basketballFieldViewModel.quarterFieldHeight)
        }
    }
    
    /// 半个的篮球场
    struct HalfBasketballField: View {
        @ObservedObject var basketballFieldViewModel: BasketballFieldViewModel
        var showSideLine: Bool

        init(basketballFieldViewModel: BasketballFieldViewModel, showSideLine: Bool) {
            self.basketballFieldViewModel = basketballFieldViewModel
            self.showSideLine = showSideLine
        }
        
        /// body
        var body: some View {
            ZStack {
                HStack(spacing: 0) {
                    QuarterBasketballField(basketballFieldViewModel: basketballFieldViewModel)
                    QuarterBasketballField(basketballFieldViewModel: basketballFieldViewModel)
                        .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                }
                
                /// 中场圈
                if showSideLine {
                    Group {
                        PathsAndShapes.CustomCircle(center: CGPoint(x: basketballFieldViewModel.quarterFieldWidth, y: basketballFieldViewModel.quarterFieldHeight - basketballFieldViewModel.mainLinesWidth), radius: basketballFieldViewModel.quarterFieldWidth/3, startAngle: 0, endAngle: 180)
                            .foregroundColor(Color(basketballFieldViewModel.colorsData.interiorLineFillColor))
                        PathsAndShapes.CustomCircle(center: CGPoint(x: basketballFieldViewModel.quarterFieldWidth, y: basketballFieldViewModel.quarterFieldHeight - basketballFieldViewModel.mainLinesWidth), radius: basketballFieldViewModel.quarterFieldWidth/3, startAngle: 0, endAngle: 180)
                            .stroke(Color(basketballFieldViewModel.colorsData.mainLinesColor), lineWidth: basketballFieldViewModel.mainLinesWidth)
                    }
                }
            }
            .frame(width: basketballFieldViewModel.fullWidth, height: basketballFieldViewModel.quarterFieldHeight)
            .border(Color(basketballFieldViewModel.colorsData.mainLinesColor), width: showSideLine ? basketballFieldViewModel.mainLinesWidth : 0)
        }
    }
    
    /// 完整的篮球场
    struct FullBasketballField: View {
        @ObservedObject var basketballFieldViewModel: BasketballFieldViewModel
        
        init(basketballFieldViewModel: BasketballFieldViewModel) {
            self.basketballFieldViewModel = basketballFieldViewModel
        }
        
        /// body
        var body: some View {
            ZStack {
                VStack(spacing: 0) {
                    HalfBasketballField(basketballFieldViewModel: basketballFieldViewModel, showSideLine: false)
                    HalfBasketballField(basketballFieldViewModel: basketballFieldViewModel, showSideLine: false)
                        .rotation3DEffect(.degrees(180), axis: (x: 1, y: 0, z: 0))
                }
                
                /// 中场线和中圈
                Group {
                    PathsAndShapes.CustomHorLinePath(startingX: 0, endX: basketballFieldViewModel.fullWidth, y: basketballFieldViewModel.quarterFieldHeight)
                        .stroke(Color(basketballFieldViewModel.colorsData.mainLinesColor), lineWidth: basketballFieldViewModel.mainLinesWidth)
                    PathsAndShapes.CustomCircle(center: CGPoint(x: basketballFieldViewModel.quarterFieldWidth, y: basketballFieldViewModel.quarterFieldHeight), radius: basketballFieldViewModel.quarterFieldWidth/3, startAngle: 0, endAngle: 360)
                        .stroke(Color(basketballFieldViewModel.colorsData.mainLinesColor), lineWidth: basketballFieldViewModel.mainLinesWidth)
                    PathsAndShapes.CustomCircle(center: CGPoint(x: basketballFieldViewModel.quarterFieldWidth, y: basketballFieldViewModel.quarterFieldHeight), radius: basketballFieldViewModel.quarterFieldWidth/3, startAngle: 0, endAngle: 360)
                        .foregroundColor(Color(basketballFieldViewModel.colorsData.interiorLineFillColor))
                }
            }
            .frame(width: basketballFieldViewModel.fullWidth, height: basketballFieldViewModel.fullHeight)
            .border(Color(basketballFieldViewModel.colorsData.mainLinesColor), width: basketballFieldViewModel.mainLinesWidth)
        }
    }
    
    /// 篮球场
    public struct BasketballField: View {
        @ObservedObject var basketballFieldViewModel: BasketballFieldViewModel
        
        public init(basketballFieldViewModel: BasketballFieldViewModel) {
            self.basketballFieldViewModel = basketballFieldViewModel
        }

        /// body
        public var body: some View {
            ZStack {
                Color(basketballFieldViewModel.colorsData.interiorFillColor)
                    .opacity(0.7)
                    .rounded(radius: 15)
                Group {
                    switch basketballFieldViewModel.templateData.type {
                    case .half:
                        HalfBasketballField(basketballFieldViewModel: basketballFieldViewModel, showSideLine: true)
                    case .full:
                        FullBasketballField(basketballFieldViewModel: basketballFieldViewModel)
                    }
                }
                .scaleEffect(basketballFieldViewModel.templateData.fieldInteriorRatio)
            }
            .frame(width: basketballFieldViewModel.fullWidth, height: basketballFieldViewModel.fullHeight)
        }
    }
}

/// 足球场视图集
public class FootballFieldViews {
    
    /// 四分之一的足球场
    struct QuarterFootballField: View {
        @ObservedObject var footballFieldViewModel: FootballFieldViewModel
        private var edages: [Edge] {
            return footballFieldViewModel.templateData.type == .half ? [.leading, .top, .bottom] : [.leading, .top]
        }
        
        init(footballFieldViewModel: FootballFieldViewModel) {
            self.footballFieldViewModel = footballFieldViewModel
        }
        
        /// body
        var body: some View {
            VStack(spacing: 0) {
                PathsAndShapes.Goal(startingPoint: CGPoint(x: footballFieldViewModel.goalpostStartingX, y: footballFieldViewModel.goalpostVerticalY))
                    .stroke(Color(footballFieldViewModel.colorsData.mainLinesColor), lineWidth: footballFieldViewModel.mainLinesWidth)
                    .frame(height: footballFieldViewModel.goalpostVerticalY)
                
                ZStack {
                    /// 草地
                    VStack(spacing: 0) {
                        footballFieldViewModel.turfColor
                        footballFieldViewModel.turfSecondaryColor
                        footballFieldViewModel.turfColor
                        footballFieldViewModel.turfSecondaryColor
                        footballFieldViewModel.turfColor
                        footballFieldViewModel.turfSecondaryColor
                    }
                    .border(width: footballFieldViewModel.mainLinesWidth, edges: edages, color: Color(footballFieldViewModel.colorsData.mainLinesColor))

                    Group {
                        /// 点球点
                        PathsAndShapes.CustomCircle(center: CGPoint(x: footballFieldViewModel.quarterFieldWidth, y: footballFieldViewModel.penaltyPointY), radius: footballFieldViewModel.mainLinesWidth*2, startAngle: 270, endAngle: 90)
                            .foregroundColor(Color(footballFieldViewModel.colorsData.mainLinesColor))
                        
                        /// 禁区
                        PathsAndShapes.PenaltyAreaPath(p1: CGPoint(x: footballFieldViewModel.penaltyAreaStartingX, y: 0), p2: CGPoint(x: footballFieldViewModel.penaltyAreaStartingX, y: footballFieldViewModel.penaltyAreaVerticalY))
                            .stroke(Color(footballFieldViewModel.colorsData.mainLinesColor), lineWidth: footballFieldViewModel.mainLinesWidth)
                        
                        /// 大禁区
                            PathsAndShapes.PenaltyAreaPath(p1: CGPoint(x: footballFieldViewModel.bigPenaltyAreaStartingX, y: 0), p2: CGPoint(x: footballFieldViewModel.bigPenaltyAreaStartingX, y: footballFieldViewModel.bigPenaltyAreaVerticalY))
                            .stroke(Color(footballFieldViewModel.colorsData.mainLinesColor), lineWidth: footballFieldViewModel.mainLinesWidth)

                        /// 角球弧
                            PathsAndShapes.CustomCircle(center: CGPoint(x: 0, y: 0), radius: 0.05*footballFieldViewModel.quarterFieldHeight, startAngle: 90, endAngle: 360)
                            .stroke(Color(footballFieldViewModel.colorsData.mainLinesColor), lineWidth: footballFieldViewModel.mainLinesWidth)
                    }
                }
            }
            .frame(width: footballFieldViewModel.quarterFieldWidth, height: footballFieldViewModel.quarterFieldHeight)
        }
    }
    
    /// 半个足球场
    struct HalfFootballField: View {
        @ObservedObject var footballFieldViewModel: FootballFieldViewModel
        var showSideLine: Bool

        init(footballFieldViewModel: FootballFieldViewModel, showSideLine: Bool = true) {
            self.footballFieldViewModel = footballFieldViewModel
            self.showSideLine = showSideLine
        }
        /// body
        var body: some View {
            ZStack {
                HStack(spacing: 0) {
                    QuarterFootballField(footballFieldViewModel: footballFieldViewModel)
                    QuarterFootballField(footballFieldViewModel: footballFieldViewModel)
                        .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                }
                
                /// 禁区弧
                PathsAndShapes.HalfPenaltyArc(startingPoint: footballFieldViewModel.arcStartingPoint, endPoint: footballFieldViewModel.arcEndPoint, controlPoint: footballFieldViewModel.arcControlPoint)
                    .offset(y: footballFieldViewModel.goalpostVerticalY)
                    .stroke(Color(footballFieldViewModel.colorsData.mainLinesColor), lineWidth: footballFieldViewModel.mainLinesWidth)
                
                /// 中圈
                Group {
                    PathsAndShapes.CustomCircle(center: CGPoint(x: footballFieldViewModel.quarterFieldWidth, y: footballFieldViewModel.quarterFieldHeight), radius: footballFieldViewModel.quarterFieldWidth*0.3, startAngle: 0, endAngle: 180)
                        .stroke(Color(footballFieldViewModel.colorsData.mainLinesColor), lineWidth: footballFieldViewModel.mainLinesWidth)
                    PathsAndShapes.CustomCircle(center: CGPoint(x: footballFieldViewModel.quarterFieldWidth, y: footballFieldViewModel.quarterFieldHeight), radius: footballFieldViewModel.mainLinesWidth*2, startAngle: 0, endAngle: 180)
                        .foregroundColor(Color(footballFieldViewModel.colorsData.mainLinesColor))
                }
            }
            .frame(width: footballFieldViewModel.quarterFieldWidth*2, height: footballFieldViewModel.quarterFieldHeight)
        }
    }
    
    /// 全场足球场
    struct FullFootballField: View {
        @ObservedObject var footballFieldViewModel: FootballFieldViewModel
        
        init(footballFieldViewModel: FootballFieldViewModel) {
            self.footballFieldViewModel = footballFieldViewModel
        }
        
        /// body
        var body: some View {
            ZStack {
                VStack(spacing: 0) {
                    HalfFootballField(footballFieldViewModel: footballFieldViewModel, showSideLine: false)
                    HalfFootballField(footballFieldViewModel: footballFieldViewModel, showSideLine: false)
                        .rotation3DEffect(.degrees(180), axis: (x: 1, y: 0, z: 0))
                }
                
                /// 中线
                Path { path in
                    path.move(to: CGPoint(x: 0, y: footballFieldViewModel.quarterFieldHeight))
                    path.addLine(to: CGPoint(x: footballFieldViewModel.fullWidth, y: footballFieldViewModel.quarterFieldHeight))
                }
                .stroke(Color(footballFieldViewModel.colorsData.mainLinesColor), lineWidth: footballFieldViewModel.mainLinesWidth)
            }
            .frame(width: footballFieldViewModel.fullWidth, height: footballFieldViewModel.fullHeight)
        }
    }
    
    /// 足球场
    public struct FootballField: View {
        @ObservedObject var footballFieldViewModel: FootballFieldViewModel
        public init(footballFieldViewModel: FootballFieldViewModel) {
            self.footballFieldViewModel = footballFieldViewModel
        }

        public var body: some View {
            ZStack(alignment: footballFieldViewModel.templateData.type == .half ? .bottom : .center) {
                footballFieldViewModel.turfColor
                    .frame(height: footballFieldViewModel.fullHeight-footballFieldViewModel.goalpostVerticalY * (footballFieldViewModel.templateData.type == .half ? 1 : 2))
                    .rounded(radius: 15)
                    
                Group {
                    switch footballFieldViewModel.templateData.type {
                    case .half:
                        HalfFootballField(footballFieldViewModel: footballFieldViewModel)
                    case .full:
                        FullFootballField(footballFieldViewModel: footballFieldViewModel)
                    }
                }
                .scaleEffect(footballFieldViewModel.templateData.fieldInteriorRatio)
            }
            .frame(width: footballFieldViewModel.fullWidth, height: footballFieldViewModel.fullHeight)
        }
    }
}

/// 球场
public struct Field: View {
    var type: GameType
    var fieldData: Data
    var width: CGFloat
    
    public init(type: GameType, fieldData: Data, width: CGFloat) {
        self.type = type
        self.fieldData = fieldData
        self.width = width
    }
    
    /// body
    public var body: some View {
        switch type {
        case .basketball:
            if let decodedFieldData = try? JSONDecoder().decode(FieldModels.BasketballFieldModel.self, from: fieldData) {
                BasketballFieldViews.BasketballField(basketballFieldViewModel: BasketballFieldViewModel(fieldData: decodedFieldData, fullWidth: width))
            } else {
                ProgressView()
            }
        case .football:
            if let decodedFieldData = try? JSONDecoder().decode(FieldModels.FootballFieldModel.self, from: fieldData) {
                FootballFieldViews.FootballField(footballFieldViewModel: FootballFieldViewModel(fieldData: decodedFieldData, fullWidth: width))
            } else {
                ProgressView()
            }
        }
    }
}

/// Paths and Shapes
class PathsAndShapes {
    /// 自定义横线
    struct CustomHorLinePath: Shape {
        var startingX: CGFloat
        var endX: CGFloat
        var y: CGFloat
        
        init(startingX: CGFloat, endX: CGFloat, y: CGFloat) {
            self.startingX = startingX
            self.endX = endX
            self.y = y
        }
        
        func path(in rect: CGRect) -> Path {
            var path = Path()
            path.move(to: CGPoint(x: startingX, y: y))
            path.addLine(to: CGPoint(x: endX, y: y))
         
            return path
        }
    }

    /// 半个三分线
    struct HalfThreePointLine: Shape {
        var threePointLineStartingX: Double
        var threePointLineStartingY: Double
        var threePointLineVerticalY: Double
        var threePointLineBottomCornerY: Double
        var threePointLineCurveControlX: Double
        var filled: Bool
        
        init(threePointLineStartingX: Double, threePointLineStartingY: Double = 0, threePointLineVerticalY: Double, threePointLineBottomCornerY: Double, threePointLineCurveControlX: Double, filled: Bool = false) {
            self.threePointLineStartingX = threePointLineStartingX
            self.threePointLineStartingY = threePointLineStartingY
            self.threePointLineVerticalY = threePointLineVerticalY
            self.threePointLineBottomCornerY = threePointLineBottomCornerY
            self.threePointLineCurveControlX = threePointLineCurveControlX
            self.filled = filled
        }
        
        func path(in rect: CGRect) -> Path {
            var path = Path()
            path.move(to: CGPoint(x: threePointLineStartingX, y: threePointLineStartingY))  //左侧为起点
            path.addLine(to: CGPoint(x: threePointLineStartingX, y: threePointLineBottomCornerY))   //左侧的底角三分线
            path.addQuadCurve(to: CGPoint(x: rect.maxX, y: threePointLineVerticalY), control: CGPoint(x: threePointLineCurveControlX, y: threePointLineVerticalY))  //半弧
            if filled {
                path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
            }
            return path
        }
    }
    
    /// 半个篮球内线
    struct HalfInteriorLine: Shape {
        var interiorLineStartingX: Double //起点x
        var interiorLineVerticalY: Double //顶点y
        var filled: Bool
        
        init(interiorLineStartingX: Double, interiorLineVerticalY: Double, filled: Bool) {
            self.interiorLineStartingX = interiorLineStartingX
            self.interiorLineVerticalY = interiorLineVerticalY
            self.filled = filled
        }
        
        func path(in rect: CGRect) -> Path {
            var path = Path()
            path.move(to: CGPoint(x: interiorLineStartingX, y: 0))
            path.addLine(to: CGPoint(x: interiorLineStartingX, y: interiorLineVerticalY))
            path.addLine(to: CGPoint(x: rect.maxX, y: interiorLineVerticalY))
            if filled {
                path.addLine(to: CGPoint(x: rect.maxX, y: 0))
            }
            return path
        }
    }
    
    /// 球员站位线
    struct PlayerPositionRectangle: Shape {
        var start_X: CGFloat
        var start_Y: CGFloat
        var vertex_X: CGFloat
        var rectangle_Height: CGFloat
        
        init(start_X: CGFloat, start_Y: CGFloat, vertex_X: CGFloat, rectangle_Height: CGFloat) {
            self.start_X = start_X
            self.start_Y = start_Y
            self.vertex_X = vertex_X
            self.rectangle_Height = rectangle_Height
        }
        
        func path(in rect: CGRect) -> Path {
            var path = Path()
            path.move(to: CGPoint(x: start_X, y: start_Y))
            path.addLine(to: CGPoint(x: vertex_X, y: start_Y))
            path.addLine(to: CGPoint(x: vertex_X, y: start_Y + rectangle_Height))
            path.addLine(to: CGPoint(x: start_X, y: start_Y + rectangle_Height))
            path.addLine(to: CGPoint(x: start_X, y: start_Y))
            return path
        }
    }

    /// 带球员站位线的内线
    struct HalfInteriorLineWithPlayerPositionLine: View {
        var interiorLineStartingX: CGFloat
        var interiorLineVerticalY: Double
        var lineWidth: CGFloat
        var width: CGFloat
        var lineColor: Color
        
        init(interiorLineStartingX: CGFloat, interiorLineVerticalY: Double, lineWidth: CGFloat, width: CGFloat, lineColor: Color) {
            self.interiorLineStartingX = interiorLineStartingX
            self.interiorLineVerticalY = interiorLineVerticalY
            self.lineWidth = lineWidth
            self.width = width
            self.lineColor = lineColor
        }
        
        /// body
        var body: some View {
            ZStack {
                HalfInteriorLine(interiorLineStartingX: interiorLineStartingX, interiorLineVerticalY: interiorLineVerticalY, filled: false)
                    .stroke(style: StrokeStyle(lineWidth: lineWidth, lineJoin: .round))
                    .foregroundColor(lineColor)
                
                /// 球员站位线
                Group {
                    PlayerPositionRectangle(start_X: interiorLineStartingX, start_Y: interiorLineVerticalY * 0.375, vertex_X: interiorLineStartingX - width*0.05, rectangle_Height: lineWidth)
                    
                    PlayerPositionRectangle(start_X: interiorLineStartingX, start_Y: interiorLineVerticalY * 0.43, vertex_X: interiorLineStartingX - width*0.05, rectangle_Height: lineWidth)

                    PlayerPositionRectangle(start_X: interiorLineStartingX, start_Y: interiorLineVerticalY * 0.57, vertex_X: interiorLineStartingX - width*0.05, rectangle_Height: lineWidth)

                    PlayerPositionRectangle(start_X: interiorLineStartingX, start_Y: interiorLineVerticalY * 0.7, vertex_X: interiorLineStartingX - width*0.05, rectangle_Height: lineWidth)
                }
                .foregroundColor(lineColor)
            }
        }
    }
    
    /// 半个罚球圈
    struct HalfFreeThrowCircle: Shape {
        var radius: CGFloat
        var centerPoint: CGPoint
        var filled: Bool
        
        init(radius: CGFloat, centerPoint: CGPoint, filled: Bool = false) {
            self.radius = radius
            self.centerPoint = centerPoint
            self.filled = filled
        }
        
        func path(in rect: CGRect) -> Path {
            var path = Path()
            path.addArc(center: CGPoint(x: centerPoint.x, y: centerPoint.y), radius: radius, startAngle: Angle(degrees: 180), endAngle: Angle(degrees: 450), clockwise: true)
            if filled {
                path.addLine(to: CGPoint(x: centerPoint.x, y: centerPoint.y))
                path.addLine(to: CGPoint(x: centerPoint.x-radius, y: centerPoint.y))
            }
            return path
        }
    }
    
    /// 自定义圆
    struct CustomCircle: Shape {
        var center: CGPoint
        var radius: CGFloat
        var startAngle: CGFloat
        var endAngle: CGFloat
        
        init(center: CGPoint, radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat) {
            self.center = center
            self.radius = radius
            self.startAngle = startAngle
            self.endAngle = endAngle
        }
        
        func path(in rect: CGRect) -> Path {
            Path { path in
                path.addArc(center: center,
                            radius: radius,
                            startAngle: .degrees(startAngle),
                            endAngle: .degrees(endAngle),
                            clockwise: true)
            }
        }
    }
    
    /// 球门
    struct Goal: Shape {
        var startingPoint: CGPoint
        
        public init(startingPoint: CGPoint) {
            self.startingPoint = startingPoint
        }
        
        func path(in rect: CGRect) -> Path {
            Path { path in
                path.move(to: CGPoint(x: startingPoint.x, y: startingPoint.y))
                path.addLine(to: CGPoint(x: startingPoint.x, y: rect.minY))
                path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
            }
        }
    }
    
    /// 半个足球禁区路径
    struct PenaltyAreaPath: Shape {
        var p1: CGPoint
        var p2: CGPoint
        
        func path(in rect: CGRect) -> Path {
            Path { path in
                path.move(to: p1)
                path.addLine(to: p2)
                path.addLine(to: CGPoint(x: rect.maxX, y: p2.y))
            }
        }
    }
    
    /// 半个足球禁区弧
    struct HalfPenaltyArc: Shape {
        var startingPoint: CGPoint
        var endPoint: CGPoint
        var controlPoint: CGPoint
        
        func path(in rect: CGRect) -> Path {
            Path { path in
                path.move(to: startingPoint)
                path.addQuadCurve(to: endPoint, control: controlPoint)
            }
        }
    }
}

/// 底部留白
public func bottomSpacer() -> some View {
    Color.clear
        .frame(height: MemberSizes.bottomSpacerHeight)
}
