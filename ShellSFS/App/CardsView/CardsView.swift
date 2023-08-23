//
//  CardsView.swift
//  ShellSFS
//
//  Created by Kagan Girgin on 5/20/23.
//

import SwiftUI

struct CardsView: View {
    @ObservedObject var viewModel = CardsViewModel()
    @State var isAddActive = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Colors.color_bg.color?
                    .ignoresSafeArea()
                if viewModel.cards.count > 0 {
                    List {
                        ForEach(viewModel.cards) { item in
                            CardsListRow(data: item).onTapGesture {
                                viewModel.selectCard(item: item)
                            }
                        }.onDelete { indexSet in
                            viewModel.onDataDelete(index: indexSet.first ?? 0)
                        }
                    }.listStyle(.plain)
                } else {
                    Text("There's no card added.")
                }
            }.toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: AddCardView(isActiveAdd: $isAddActive), isActive: $isAddActive) {
                        Label("Add", systemImage: "plus.circle.fill")
                    }
                }
            }
            .navigationTitle("Cards")
            .onAppear {
                viewModel.getCards()
            }
        }
    }
}

struct CardsView_Previews: PreviewProvider {
    static var previews: some View {
        CardsView()
    }
}
