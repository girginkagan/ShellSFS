//
//  CardsListRow.swift
//  ShellSFS
//
//  Created by Kagan Girgin on 5/20/23.
//

import SwiftUI

struct CardsListRow: View {
    var data: CardResponseModel
    
    var body: some View {
        ZStack {
            Colors.color_bg.color?.ignoresSafeArea()
            VStack (alignment: .leading, spacing: 20) {
                ZStack {
                    Images.ic_card.image?.resizable()
                        .aspectRatio(contentMode: .fit)
                }.padding(EdgeInsets(top: 10, leading: 10, bottom: 5, trailing: 10))
                    .overlay(CardOverlayView(cardDetail: nil, data: data), alignment: .bottomLeading)
            }
        }.listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
    }
}

struct CardsListRow_Previews: PreviewProvider {
    static var previews: some View {
        CardsListRow(data: CardResponseModel(cardNumber: "1234512345", cardUser: "KAGAN GIRGIN", cardCompany: "futureworks", isSelected: true))
    }
}
