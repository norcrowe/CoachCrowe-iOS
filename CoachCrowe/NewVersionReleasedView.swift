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
                .foregroundColor(Color(ColorSelection.primary))
            Text(versionID)
                .font(.caption.bold())
                .foregroundColor(Color(ColorSelection.primary))
                
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
