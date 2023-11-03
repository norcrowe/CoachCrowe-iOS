import SwiftUI
import CoachCroweBasic
import CoachCroweViewModels
import CoachCroweViewKit

struct MasterView: View {
    @StateObject var masterViewModel: MasterViewModel = MasterViewModel()
    
    /// body
    var body: some View {
        Group {
            if masterViewModel.initializationState != nil {
                InitializationView(masterViewModel: masterViewModel)
                    .transition(.offset(x: -MemberSizes.screenWidth).combined(with: .opacity))
            } else {
                MainView(masterViewModel: masterViewModel)
            }
        }
        .animation(.spring, value: masterViewModel.initializationState)
    }
}

/// Main View
struct MainView: View {
    @ObservedObject var masterViewModel: MasterViewModel
    
    /// body
    var body: some View {
        HStack(spacing: 0) {
            SideBar(currentSelection: $masterViewModel.mainViewState)
            LibraryView(masterViewModel: masterViewModel)
                .overlay(
                    Color.black
                        .ignoresSafeArea()
                        .opacity(masterViewModel.showSideBar ? 0.2 : 0)
                        .onTapGesture {
                            withAnimation(.spring) {
                                masterViewModel.showSideBar = false
                            }
                        }
                )
        }
        .frame(width: MemberSizes.screenWidth + MemberSizes.sideBarWidth)
        .offset(x: -MemberSizes.sideBarWidth/2)
        .offset(x: masterViewModel.showSideBar ? MemberSizes.sideBarWidth : 0)
    }
}
