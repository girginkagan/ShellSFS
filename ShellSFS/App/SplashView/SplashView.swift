//
//  SplashView.swift
//  ShellSFS
//
//  Created by Kagan Girgin on 5/19/23.
//

import SwiftUI

struct SplashView: View {
    @State var isReady = false
    let viewModel = SplashViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                if isReady {
                    TabBarView()
                } else {
                    Colors.color_bg.color?.ignoresSafeArea()
                    Images.ic_logo.image?
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                    VStack {
                        Spacer()
                        ProgressView().progressViewStyle(CircularProgressViewStyle(tint: Colors.color_primary.color ?? .accentColor))
                            .scaleEffect(1.5)
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 50, trailing: 0))
                    }
                }
            }.onAppear() {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                    withAnimation {
                        self.viewModel.getCards { data in
                            self.isReady = data
                        }
                    }
                })
            }
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
