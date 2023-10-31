import Foundation
import SwiftUI
import CoachCroweBasic

/// 验证码输入框
public func TextBox(text: String, index: Int, isKeyboardShowing: Bool, action: @escaping () -> Void) -> some View {
    ZStack {
        if text.count > index {
            let startIndex = text.startIndex
            let charIndex = text.index(startIndex, offsetBy: index)
            let charToString = String(text[charIndex])
            
            Text(charToString)
                .animation(.spring)
        } else {
            Text("")
        }
    }
    .frame(width: MemberSizes.controlHeight, height: MemberSizes.controlHeight)
    .background {
        let status = (isKeyboardShowing && text.count == index)
        ZStack {
            RoundedRectangle(cornerRadius: 5, style: .continuous)
                .stroke(status ? Color("primary") : Color(ColorSelection.gray), lineWidth: status ? 1 : 0.5)
                .animation(.spring, value: status)
            RoundedRectangle(cornerRadius: 5, style: .continuous)
                .opacity(0.001)
        }
        .onTapGesture {
            action()
        }

    }
    .frame(maxWidth: .infinity)
}

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
