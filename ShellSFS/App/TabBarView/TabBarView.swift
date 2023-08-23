//
//  TabBarView.swift
//  ShellSFS
//
//  Created by Kagan Girgin on 5/20/23.
//

import SwiftUI

struct TabBarView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Text("Home")
                    Images.ic_tab_home.image
                }
            CardsView()
                .tabItem {
                    Text("Cards")
                    Images.ic_tab_cards.image
                }
        }.accentColor(Colors.color_primary.color)
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
