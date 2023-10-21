import SwiftUI
import CoachCroweBasic
import CoachCroweViewKit
import CoachCroweViewModels
import AnimateText

struct InitializationView: View {
    @ObservedObject var masterViewModel: MasterViewModel
    @State private var logoHeight: CGFloat = MemberSizes.screenWidth * 0.8
    
    /// body
    var body: some View {
        VStack(spacing: 10) {
            if masterViewModel.initializationState != .needLogin && masterViewModel.initializationState != .failed {
                Spacer()
                RotatingCoachCrowe(height: logoHeight)
                    .transition(.offset(x: -MemberSizes.screenWidth, y: 0))
                    .onAppear {
                        withAnimation(.spring) {
                            logoHeight = MemberSizes.screenWidth*0.25
                        }
                    }
            }
            switch masterViewModel.initializationState {
            case .initializing:
                Zelda()
                Spacer()
            case .failed:
                ErrorView(text: "Initialization failed") {
                    DispatchQueue.main.async {
                        withAnimation(.spring) {
                            masterViewModel.initializationState = .initializing
                        }
                    }
                    masterViewModel.initialization()
                    
                }
            case .welcome:
                WelcomeView(initializationState: $masterViewModel.initializationState)
                    .transition(.offset(x: -MemberSizes.screenWidth, y: 0))
            case .needLogin:
                LoginView(masterViewModel: masterViewModel)
            case .newVersionReleased(let versionID, let downloadURL):
                NewVersionReleasedView(versionID: versionID, downloadURL: downloadURL)
            case .none:
                EmptyView()
            }
            
        }
        .fullBackgroundColor()
    }
}

/// 欢迎界面
struct WelcomeView: View {
    @Binding var initializationState: InitializationState?
    @State private var title: String = ""
    @State private var caption: String = ""
    @State private var showLoginButton: Bool = false
    
    /// body
    var body: some View {
        VStack(spacing: 10) {
            AnimateText<ATSlideEffect>($title, type: .letters)
                .font(.title.bold())
            AnimateText<ATOpacityEffect>($caption, type: .letters)
                .caption()
            Spacer()
            if showLoginButton {
                Button {
                    withAnimation(.spring) {
                        initializationState = .needLogin
                    }
                } label: {
                    Text(key: "Start")
                        .foregroundStyle(.white)
                        .font(.body.bold())
                        .padding(.vertical, 15)
                        .frame(width: MemberSizes.componentWidth)
                        .roundedColorBackground(color: .blue, radius: 15)
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                title = NSLocalizedString("Welcome Here", comment: "")
            }
            DispatchQueue.main.asyncAfter(deadline: .now()+2.5) {
                caption = NSLocalizedString("Probably the best tactical board App👀", comment: "")
            }
            DispatchQueue.main.asyncAfter(deadline: .now()+4) {
                withAnimation(.spring) {
                    showLoginButton = true
                }
            }
            
        }
    }
}
