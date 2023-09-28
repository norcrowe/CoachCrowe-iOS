//
//  Enums.swift
//
//
//  Created by Nor CrowE on 2023/9/28.
//

import Foundation

/// 主视图状态
enum MasterViewState: String, Identifiable, CaseIterable {
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

