//
//  ProgressHUD.swift
//  ShellSFS
//
//  Created by Kagan Girgin on 5/20/23.
//

import SwiftUI

protocol ProgressHUDControls {
    func showProgressBarHUD()
    func hideProgressBarHUD()
}

struct ProgressHUD: View {
    static var shared = ProgressHUD()
    var controls: ProgressHUDControls?
    
    var body: some View {
        ZStack {
            Colors.color_progresshud_bg.color?.ignoresSafeArea()
            VStack {
                ProgressView().progressViewStyle(CircularProgressViewStyle(tint: Colors.color_primary.color ?? .accentColor))
                    .scaleEffect(2)
                    .padding(EdgeInsets(top: 50, leading: 50, bottom: 50, trailing: 50))
            }.background(Colors.color_bg.color)
                .cornerRadius(15)
        }
    }
    
    func showProgressBar() {
        controls?.showProgressBarHUD()
    }
    
    func hideProgressBar() {
        controls?.hideProgressBarHUD()
    }
}

struct ProgressHUD_Previews: PreviewProvider {
    static var previews: some View {
        ProgressHUD()
    }
}
