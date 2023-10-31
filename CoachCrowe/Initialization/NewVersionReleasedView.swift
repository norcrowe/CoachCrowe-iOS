import SwiftUI
import CoachCroweBasic
import CoachCroweViewKit
import CoachCroweViewModels

struct NewVersionReleasedView: View {
    let versionID: String
    let downloadURL: URL
    
    /// body
    var body: some View {
        VStack(spacing: 5) {
            Text(key: "New Version Released")
                .font(.title.bold())
                .colored(.primaryColor)
            Text(versionID)
                .font(.caption.bold())
                .colored(.primaryColor)
                
            Spacer()
        
            Button {
                UIApplication.shared.open(downloadURL)
            } label: {
                Text(key: "Update")
                    .foregroundStyle(.white)
                    .font(.body.bold())
                    .padding(.vertical, 15)
                    .frame(width: MemberSizes.componentWidth)
                    .roundedColorBackground(color: .blue, radius: 15)
            }

        }
    }
}
