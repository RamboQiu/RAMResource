//
//  DemoApp.swift
//  Demo
//
//  Created by 裘俊云 on 2023/6/21.
//

import SwiftUI
import Component
import Component2

@main
struct DemoApp: App {
    var body: some Scene {
        WindowGroup {
            VStack {
                ComponentVC()
                Component2VC()
            }
            .padding()
        }
    }
}
