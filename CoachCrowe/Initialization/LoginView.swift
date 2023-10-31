import SwiftUI
import CoachCroweViewModels
import CoachCroweBasic
import CoachCroweViewKit

struct LoginView: View {
    @ObservedObject var masterViewModel: MasterViewModel
    @StateObject private var loginViewModel: LoginViewModel = LoginViewModel()

    /// body
    var body: some View {
        Group {
            switch loginViewModel.viewState {
            case .inputPhoneNumber:
                InputPhoneNumberView(masterViewModel: masterViewModel, loginViewModel: loginViewModel)
                    .transition(.asymmetric(insertion: .offset(x: MemberSizes.screenWidth), removal: .offset(x: -MemberSizes.screenWidth)))
            case .inputVerificationCode:
                InputVerificationCodeView(masterViewModel: masterViewModel, loginViewModel: loginViewModel)
                    .transition(.asymmetric(insertion: .offset(x: MemberSizes.screenWidth), removal: .offset(x: -MemberSizes.screenWidth)))
            case .signup:
                SignupView(masterViewModel: masterViewModel, loginViewModel: loginViewModel)
                    .transition(.asymmetric(insertion: .offset(x: MemberSizes.screenWidth), removal: .offset(x: -MemberSizes.screenWidth)))
            }
        }
        .hud(hudState: $loginViewModel.hudState)
    }
}

/// 输入手机号界面
struct InputPhoneNumberView: View {
    @ObservedObject var masterViewModel: MasterViewModel
    @ObservedObject var loginViewModel: LoginViewModel
    let countrys: [Region] = [.china, .portugal]
    @State private var showRegionPickerSheet: Bool = false
    
    /// body
    var body: some View {
        VStack(spacing: 10) {

            HideKeyboardSpacer()

            VStack(spacing: 5) {
                Text(key: "Your Phone Number")
                    .font(.title.bold())
                Text(key: "Enter phone number to begin verification")
                    .caption()
            }

            HStack(spacing: 7.5) {
                
                Button {
                    showRegionPickerSheet = true
                } label: {
                    Text(loginViewModel.region.flag + loginViewModel.region.number)
                        .colored(.primaryColor)
                        .font(.body.bold())
                        .padding(10)
                        .roundedColorBackground(color: Color(ColorSelection.secondary), radius: 10)
                }
                
                TextField(NSLocalizedString("Phone Number", comment: ""), text: $loginViewModel.phoneNumber)
                    .keyboardType(.numberPad)
                    .padding(10)
                    .roundedColorBackground(color: Color(ColorSelection.secondary), radius: 10)
            }

            HideKeyboardSpacer()
                
            RoundedFillColorNextStepButton(text: "Send code") {
                loginViewModel.alert = .init(showAlert: true, title: "Verify your phone number", caption: loginViewModel.fullPhoneNumber)
            }
            .customDisabled(loginViewModel.phoneNumber.count<5)
        }
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
        .frame(width: MemberSizes.componentWidth)
        .sheet(isPresented: $showRegionPickerSheet) {
            RegionPicker(region: $loginViewModel.region, show: $showRegionPickerSheet)
                .backgroundColor(Color(ColorSelection.backgroundColor))
        }
        .alert(isPresented: $loginViewModel.alert.showAlert) {
            Alert(
                title: Text(key: loginViewModel.alert.title),
                message: Text(key: loginViewModel.alert.caption),
                primaryButton: .default(Text(key: "Sent")) {
                    loginViewModel.sentVerificationCode()
                    loginViewModel.alert.showAlert = .init()
                },
                secondaryButton: .cancel(Text("Cancel")) {
                    loginViewModel.alert.showAlert = .init()
                }
            )
        }

    }
}

/// 输入验证码界面
struct InputVerificationCodeView: View {
    @ObservedObject var masterViewModel: MasterViewModel
    @ObservedObject var loginViewModel: LoginViewModel
    @FocusState var isKeyboardShowing: Bool
    
    /// body
    var body: some View {
        VStack(spacing: 10) {
            HideKeyboardSpacer()
            VStack(spacing: 5) {
                Text(key: "Enter Verification Code")
                    .font(.title.bold())
                Text(String(format: NSLocalizedString("The verification code has been sent to the phone number ending in %1$@", comment: ""), String(loginViewModel.phoneNumber.suffix(4))))
                    .caption()
            }
            
            HStack(spacing: 0) {
                ForEach(0..<6, id: \.self) { index in
                    TextBox(text: loginViewModel.verificationCode, index: index, isKeyboardShowing: isKeyboardShowing) {
                        withAnimation(.spring) {
                            isKeyboardShowing.toggle()
                        }
                    }
                }
            }
            .background(
                TextField("", text: $loginViewModel.verificationCode.limit(6))
                    .keyboardType(.numberPad)
                    .textContentType(.oneTimeCode)
                    .frame(width: 1, height: 1)
                    .frame(maxWidth: 42, maxHeight: 42)
                    .opacity(0.01)
                    .blendMode(.screen)
                    .focused($isKeyboardShowing)
                    .onChange(of: loginViewModel.verificationCode.count) { count in
                        if count == 6 {
                            UIApplication.shared.endEditing()
                        }
                    }
            )

            HideKeyboardSpacer()
            HStack(spacing: 5) {
                CircledFillColorSFSymbolButton(sFSymbolName: "arrow.left") {
                    loginViewModel.alert = .init(showAlert: true, title: "Return to number input", caption: "Sure to do?")
                }

                RoundedFillColorNextStepButton(text: "Confirm") {
                    loginViewModel.login {
                        withAnimation(.spring) {
                            masterViewModel.initializationState = nil
                        }
                    }
                }
                .customDisabled(loginViewModel.verificationCode.count != 6)
            }
        }
        .onAppear {
            isKeyboardShowing.toggle()
        }
        .frame(width: MemberSizes.componentWidth)
        .alert(isPresented: $loginViewModel.alert.showAlert) {
            Alert(
                title: Text(key: loginViewModel.alert.title),
                message: Text(key: loginViewModel.alert.caption),
                primaryButton: .default(Text(key: "Confirm")) {
                    withAnimation(.spring) {
                        loginViewModel.viewState = .inputPhoneNumber
                    }
                    loginViewModel.alert.showAlert = .init()
                },
                secondaryButton: .cancel(Text("Cancel")) {
                    loginViewModel.alert.showAlert = .init()
                }
            )
        }

    }
    
}

/// 注册界面
struct SignupView: View {
    @ObservedObject var masterViewModel: MasterViewModel
    @ObservedObject var loginViewModel: LoginViewModel
    
    /// body
    var body: some View {
        VStack(spacing: 10) {
            HideKeyboardSpacer()
            VStack(spacing: 5) {
                Text(key: "Sign Up")
                    .font(.title.bold())
                Text("Enter your picture and name")
                    .caption()
            }
            
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
                
                Group {
                    TextField(NSLocalizedString("Name", comment: ""), text: $loginViewModel.name)
                        .padding(10)
                        .roundedColorBackground(color: Color(ColorSelection.secondary), radius: 10)
                    TextField(NSLocalizedString("Code", comment: ""), text: $loginViewModel.verificationCode)
                        .padding(10)
                        .roundedColorBackground(color: Color(ColorSelection.secondary), radius: 10)
                }
            }
            
            HideKeyboardSpacer()
            
            HStack(spacing: 5) {
                CircledFillColorSFSymbolButton(sFSymbolName: "arrow.left") {
                    loginViewModel.alert = .init(showAlert: true, title: "Return to number input", caption: "Sure to do")
                }
                RoundedFillColorNextStepButton(text: "Confirm") {
                    withAnimation(.spring) {
                        UIApplication.shared.endEditing()
                    }
                    loginViewModel.signup {
                        withAnimation(.spring) {
                            masterViewModel.initializationState = nil
                        }
                    }
                }
                .customDisabled(loginViewModel.verificationCode.count != 6 || loginViewModel.image == nil || loginViewModel.name == "")

            }

        }
        .onChange(of: loginViewModel.image) { _ in
            loginViewModel.showCropView.toggle()
        }
        .frame(width: MemberSizes.componentWidth)
        .sheet(isPresented: $loginViewModel.showImagePicker) {
            ImagePicker(selectedImage: $loginViewModel.image)
                .ignoresSafeArea()
        }
        .alert(isPresented: $loginViewModel.alert.showAlert) {
            Alert(
                title: Text(key: loginViewModel.alert.title),
                message: Text(key: loginViewModel.alert.caption),
                primaryButton: .default(Text(key: "Confirm")) {
                    withAnimation(.spring) {
                        loginViewModel.viewState = .inputPhoneNumber
                    }
                    loginViewModel.alert.showAlert = .init()
                },
                secondaryButton: .cancel(Text("Cancel")) {
                    loginViewModel.alert.showAlert = .init()
                }
            )
        }

    }
}
