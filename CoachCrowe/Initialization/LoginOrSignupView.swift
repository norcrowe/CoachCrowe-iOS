import SwiftUI
import CoachCroweViewModels
import CoachCroweBasic
import CoachCroweViewKit

struct LoginOrSignupView: View {
    @ObservedObject var masterViewModel: MasterViewModel
    @StateObject private var loginViewModel: LoginViewModel = LoginViewModel()

    /// body
    var body: some View {
        Group {
            switch loginViewModel.viewState {
            case .login:
                LoginView(masterViewModel: masterViewModel, loginViewModel: loginViewModel)
                    .transition(.asymmetric(insertion: .offset(x: MemberSizes.screenWidth).combined(with: .opacity), removal: .offset(x: -MemberSizes.screenWidth).combined(with: .opacity)))
            case .signup:
                SignupView(masterViewModel: masterViewModel, loginViewModel: loginViewModel)
                    .transition(.asymmetric(insertion: .offset(x: MemberSizes.screenWidth).combined(with: .opacity), removal: .offset(x: -MemberSizes.screenWidth).combined(with: .opacity)))
            }
        }
        .hud(hudState: $loginViewModel.hudState)
    }
}

/// 登录界面
struct LoginView: View {
    @ObservedObject var masterViewModel: MasterViewModel
    @ObservedObject var loginViewModel: LoginViewModel
    
    /// body
    var body: some View {
        VStack(spacing: 15) {

            HideKeyboardSpacer()

            VStack(spacing: 5) {
                Text(key: "Log in")
                    .font(.title.bold())
            }
            
            LoginViewTextField(text: $loginViewModel.id, sFSymbolName: "person.fill", description: "ID")

            LoginViewTextField(text: $loginViewModel.password, sFSymbolName: "key.fill", description: "Password", forPassword: true)

            
            HideKeyboardSpacer()
            
            HStack(spacing: 5) {
                RoundedFillColorNextStepButton(text: "Sign up", fillColor: Color(0x2E4374)) {
                    withAnimation(.spring) {
                        loginViewModel.viewState = .signup
                    }
                }
                .frame(width: MemberSizes.componentWidth/3 - 2.5)
                
                RoundedFillColorNextStepButton(text: "Log in") {
                    loginViewModel.passwordLogin {
                            masterViewModel.initializationState = nil
                        
                    }
                }
                .frame(width: (MemberSizes.componentWidth * 2/3) - 2.5)
            }
            
            bottomSpacer()

        }
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
        .frame(width: MemberSizes.componentWidth)
    }
}

/// 注册界面
struct SignupView: View {
    @ObservedObject var masterViewModel: MasterViewModel
    @ObservedObject var loginViewModel: LoginViewModel
    
    /// body
    var body: some View {
        VStack(spacing: 15) {
            HideKeyboardSpacer()
            
            Text(key: "Sign up")
                .font(.title.bold())
            
            VStack(spacing: 5) {
                Button {
                    loginViewModel.showImagePicker = true
                } label: {
                    if let image = loginViewModel.image {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } else {
                        Image(systemName: "photo.fill")
                            .font(.title.bold())
                            .colored(.primaryColor)
                    }
                    
                }
                .frame(width: 100, height: 100)
                .roundedColorBackground(color: Color(ColorSelection.secondary), radius: 25)
                .overlay(
                    Group {
                        RoundedRectangle(cornerRadius: 25, style: .continuous)
                            .stroke(Color(ColorSelection.secondary), lineWidth: loginViewModel.image != nil ? 1 : 0)
                    }
                )
                LoginViewTextField(text: $loginViewModel.id, sFSymbolName: "person.fill", description: "ID")
                LoginViewTextField(text: $loginViewModel.password, sFSymbolName: "key.fill", description: "Password", forPassword: true)
            }
            
            HideKeyboardSpacer()
            
            HStack(spacing: 5) {
                RoundedFillColorNextStepButton(text: "Log in", fillColor: Color(0x2E4374)) {
                    withAnimation(.spring) {
                        loginViewModel.viewState = .login
                    }
                }
                .frame(width: 140)
                
                RoundedFillColorNextStepButton(text: "Sign up") {
                    loginViewModel.passwordSignup {
                        masterViewModel.initializationState = nil
                    }
                }
            }
            bottomSpacer()

        }
        .frame(width: MemberSizes.componentWidth)
        .sheet(isPresented: $loginViewModel.showImagePicker) {
            ImagePicker(selectedImage: $loginViewModel.image)
                .ignoresSafeArea()
        }
    }
}
