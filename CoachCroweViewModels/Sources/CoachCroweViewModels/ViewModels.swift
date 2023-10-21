//
//  CoachCroweViewModels.swift
//
//
//  Created by Nor CrowE on 2023/9/28.
//

import Foundation
import CoachCroweBasic

class masterViewModel: ObservableObject {
    @Published var viewState: MasterViewState = .library
    @Published var selectedSelection: [MasterViewState] = [.library]
    
}
