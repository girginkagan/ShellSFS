//
//  AddCardView.swift
//  ShellSFS
//
//  Created by Kagan Girgin on 5/21/23.
//

import SwiftUI

struct AddCardView: View {
    @State private var cardHolder = ""
    @State private var cardNumber = ""
    @State private var company = ""
    @Binding var isActiveAdd: Bool
    @ObservedObject private var viewModel = AddCardViewModel()
    
    var body: some View {
        let isAlert = Binding<BaseErrorModel?>(
            get: { self.viewModel.isAlert },
            set: { _ in self.viewModel.isAlert = nil }
        )
        ZStack {
            Colors.color_bg.color?.ignoresSafeArea()
            VStack(spacing: 25) {
                TextField("Card Number", text: $cardNumber)
                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                    .frame(height: 50)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Colors.color_primary.color ?? .black, lineWidth: 2)
                        ).keyboardType(.numberPad)
                TextField("Card Holder", text: $cardHolder)
                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                    .frame(height: 50)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Colors.color_primary.color ?? .black, lineWidth: 2)
                        )
                TextField("Company", text: $company)
                    .frame(height: 50)
                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Colors.color_primary.color ?? .black, lineWidth: 2)
                        )
                Button("Add") {
                    if cardHolder != "" && cardNumber != "" && company != "" {
                        viewModel.addCard(card: CardResponseModel(id: UUID().uuidString, cardNumber: cardNumber, cardUser: cardHolder, cardCompany: company, isSelected: true))
                        isActiveAdd = false
                    } else {
                        viewModel.isAlert = BaseErrorModel(errorCode: nil, message: "You must fill out all of the fields.", errors: nil)
                    }
                }.frame(maxWidth: .infinity, maxHeight: 50)
                    .background(Colors.color_primary.color)
                    .cornerRadius(10)
                    .foregroundColor(.black)
                Spacer()
            }.padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                .alert(item: isAlert) { data in
                    Alert(title: Text("Warning"), message: Text(data.message ?? ""), dismissButton: .default(Text("OK")))
                }
        }
    }
}

struct AddCardView_Previews: PreviewProvider {
    @State static var isActiveAdd = true
    static var previews: some View {
        AddCardView(isActiveAdd: $isActiveAdd)
    }
}
