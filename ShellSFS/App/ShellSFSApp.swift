//
//  ShellSFSApp.swift
//  ShellSFS
//
//  Created by Kagan Girgin on 5/19/23.
//

import SwiftUI
import Combine

@main
struct ShellSFSApp: App {
    @State var isProgressSeen = false
    var progressView = ProgressHUD.shared
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                SplashView()
                if isProgressSeen {
                    progressView
                }
            }.onAppear {
                ProgressHUD.shared.controls = self
            }
        }
    }
}

extension ShellSFSApp: ProgressHUDControls {
    func hideProgressBarHUD() {
        isProgressSeen = false
    }
    
    func showProgressBarHUD() {
        isProgressSeen = true
    }
}
