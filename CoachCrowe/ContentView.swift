//
//  ContentView.swift
//  CoachCrowe
//
//  Created by Nor CrowE on 2023/9/27.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        HStack(spacing: 0) {
            SideSelectionBar()
            Text("主视图")
                .ignoresSafeArea()
                .background(Color("background"))
        }
    }
}
