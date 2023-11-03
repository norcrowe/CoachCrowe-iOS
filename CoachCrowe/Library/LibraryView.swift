import SwiftUI
import CoachCroweBasic
import CoachCroweViewModels
import CoachCroweViewKit

struct LibraryView: View {
    @ObservedObject var masterViewModel: MasterViewModel
    /// body
    var body: some View {
        NavigationView {
            ScrollView {
                Spacer()
                    .frame(height: MemberSizes.safeAreaInsets.top + MemberSizes.mainViewHeadBarHeight)
            }
            .mainViewHeadBar(title: "战术库", showSideBar: $masterViewModel.showSideBar) {
                Menu {
                    Button {
                        
                    } label: {
                        Label(NSLocalizedString("Basketball", comment: ""), image: "basketball")
                            .colored(.primaryColor)
                    }
                    
                    Button {
                        
                    } label: {
                        Label(NSLocalizedString("Football", comment: ""), image: "football")
                            .colored(.primaryColor)
                    }
                } label: {
                    Image(systemName: "plus")
                        .colored(.primaryColor)
                        .font(.title3)
                        .frame(maxWidth: MemberSizes.controlSecondaryHeight, maxHeight: MemberSizes.controlSecondaryHeight)
                        .roundedColorBackground(color: Color(ColorSelection.secondary), radius: 99)
                }
            }
            .fullBackgroundColor()
            .navigationBarHidden(true)
            .navigationViewStyle(.stack)
            .ignoresSafeArea()
        }
    }
}
