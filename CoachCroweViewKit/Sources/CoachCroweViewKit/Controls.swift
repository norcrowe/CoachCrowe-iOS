import Foundation
import SwiftUI
import CoachCroweBasic

/// 圆角+填充色的下一步按钮
public func RoundedFillColorNextStepButton(text: String, fillColor: Color = .blue, action: @escaping () -> Void) -> some View {
    Button {
        action()
    } label: {
        Text(key: text)
            .foregroundColor(.white)
            .font(.body.bold())
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .roundedColorBackground(color: fillColor, radius: 15)
    }
}

/// 圆形+填充色的SFSymbol按钮
public func CircledFillColorSFSymbolButton(sFSymbolName: String, fillColor: Color = Color(ColorSelection.secondary), sFSymbolColor: Color = Color(ColorSelection.primaryColor), action: @escaping () -> Void) -> some View {
    Button {
        action()
    } label: {
        Image(systemName: sFSymbolName)
            .font(.body.bold())
            .colored(.primaryColor)
            .frame(width: MemberSizes.controlHeight, height: MemberSizes.controlHeight)
            .roundedColorBackground(color: Color(ColorSelection.secondary), radius: 99)
    }
}

/// 点击后隐藏键盘的Spacer
public func HideKeyboardSpacer() -> some View {
    Button {
        UIApplication.shared.endEditing()
    } label: {
        Color.clear
    }
}

/// Side Bar Button
public func SideBarButton(showSideBar: Binding<Bool>) -> some View {
    Button {
        withAnimation(.spring) {
            showSideBar.wrappedValue.toggle()
        }
    } label: {
        Image(systemName: "sidebar.squares.left")
            .font(.title2)
            .colored(.blue)
            .frame(height: MemberSizes.controlSecondaryHeight)
    }
}

/// 登录界面的输入框
public func LoginViewTextField(text: Binding<String>, sFSymbolName: String, description: String, forPassword: Bool = false) -> some View {
    HStack(spacing: 5) {
        Image(systemName: sFSymbolName)
            .frame(width: MemberSizes.controlHeight, height: MemberSizes.controlHeight)
            .roundedColorBackground(color: Color(ColorSelection.secondary), radius: 10)

        Group {
            if forPassword {
                SecureField(NSLocalizedString(description, comment: ""), text: text)
            } else {
                TextField(NSLocalizedString(description, comment: ""), text: text)
            }
        }
        .keyboardType(.twitter)
        .padding(10)
        .frame(height: MemberSizes.controlHeight)
        .roundedColorBackground(color: Color(ColorSelection.secondary), radius: 10)
    }
}
