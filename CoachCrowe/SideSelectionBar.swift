//
//  SideSelectionBar.swift
//  CoachCrowe
//
//  Created by Nor CrowE on 2023/9/27.
//

import SwiftUI

struct SideSelectionBar: View {
    let width: CGFloat = 260
    @State var selection: Selection = .library
    @Namespace var namespace
    
    var body: some View {
        VStack {
            ForEach(Selection.allCases) { selection in
                Button {
                    withAnimation(.none) {
                        self.selection = selection
                    }
                } label: {
                    selectionLable(selection: selection, selected: self.selection == selection)
                }   
            }
        }
        .frame(width: width)
        .ignoresSafeArea()
        .background(Color(.white))
    }
    
    @ViewBuilder
    func selectionLable(selection: Selection, selected: Bool) -> some View {
        HStack(spacing: 5) {
            Image(systemName: selected ? selection.sfSymbolName + ".fill" : selection.sfSymbolName)
                .foregroundColor(selected ? .white : .black)
                .frame(maxWidth: 35)
            Text(selection.description)
                .foregroundColor(selected ? .white : .black)
            Spacer()
        }
        .font(.title2)
        .padding(7.5)
        .background(
            RoundedRectangle(cornerRadius: 15, style: .continuous)
                .foregroundColor(.blue)
                .opacity(selected ? 1 : 0)
        )

    }

}


enum Selection: String, CaseIterable, Identifiable {
    case library
    case shared
    case community
    case settings
    
    var id: String { self.rawValue }
    
    var description: String {
        switch self {
        case .library:
            return "Library"
        case .shared:
            return "Shared"
        case .community:
            return "Community"
        case .settings:
            return "Settings"
        }
    }
    
    var sfSymbolName: String {
        switch self {
        case .library:
            return "house"
        case .shared:
            return "bolt.horizontal"
        case .community:
            return "shippingbox"
        case .settings:
            return "gear.circle"
        }
    }
}
