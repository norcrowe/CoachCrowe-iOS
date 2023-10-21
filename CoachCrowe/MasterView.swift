import SwiftUI
import CoachCroweBasic
import CoachCroweViewModels
import CoachCroweViewKit

struct MasterView: View {
    @StateObject var masterViewModel: MasterViewModel = MasterViewModel()
    
    /// body
    var body: some View {
        if let initializationState = masterViewModel.initializationState {
            InitializationView(masterViewModel: masterViewModel)
                .transition(.offset(x: -MemberSizes.screenWidth).combined(with: .opacity))
        } else {
            
        }
    }
}
