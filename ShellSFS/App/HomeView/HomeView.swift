//
//  HomeView.swift
//  ShellSFS
//
//  Created by Kagan Girgin on 5/20/23.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel = HomeViewModel()
    @State var data: CardResponseModel?
    @State var cardDetail: CardDetailResponseModel?
    
    var body: some View {
        let isAlert = Binding<BaseErrorModel?>(
            get: { self.viewModel.isAlert },
            set: { _ in self.viewModel.isAlert = self.viewModel.isAlert }
        )
        NavigationView {
            ZStack {
                Colors.color_bg.color?
                    .ignoresSafeArea()
                if let data = data {
                    VStack (alignment: .leading, spacing: 20) {
                        ZStack {
                            Images.ic_card.image?.resizable()
                                .aspectRatio(contentMode: .fit)
                        }.padding(EdgeInsets(top: 20, leading: 10, bottom: 0, trailing: 10))
                            .overlay(CardOverlayView(cardDetail: cardDetail, data: data), alignment: .bottomLeading)
                        HStack {
                            Text("Card Status")
                                .foregroundColor(Colors.color_accent.color)
                                .font(.system(size: 18, weight: .regular))
                            Spacer()
                            Text((CardStatusNames(rawValue: cardDetail?.cardStatusName ?? "") ?? .closed) == .open ? "Open" : "Close")
                                .foregroundColor(Colors.color_primary.color)
                                .font(.system(size: 18, weight: .semibold))
                        }.padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                        Spacer()
                    }
                } else {
                    Text("There's no card added.")
                }
            }
            .navigationTitle("Balance")
        }.navigationBarTitleDisplayMode(.large)
            .onAppear {
                if data == nil || data?.id != viewModel.getSelectedCard(progress: false)?.id {
                    data = viewModel.getSelectedCard()
                    
                    setBindings()
                    if data != nil {
                        viewModel.getCardDetail()
                    }
                }
            }
            .alert(item: isAlert) { data in
                Alert(title: Text("Warning"), message: Text(data.message ?? ""), dismissButton: .default(Text("OK")))
            }
    }
    
    private func setBindings() {
        viewModel.cardData.sink(receiveValue: { data in
            cardDetail = data
        }).store(in: &viewModel.cancellables)
        
        viewModel.onProgressVisibilityChanged.sink { visible in
            if visible {
                ProgressHUD.shared.showProgressBar()
            } else {
                ProgressHUD.shared.hideProgressBar()
            }
        }.store(in: &viewModel.cancellables)
    }
}

struct CardOverlayView: View {
    var cardDetail: CardDetailResponseModel?
    let data: CardResponseModel
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(data.cardNumber ?? "")
                    .foregroundColor(Colors.color_white.color)
                    .font(.system(size: 15, weight: .medium))
                Text(data.cardUser ?? "")
                    .foregroundColor(Colors.color_white.color)
                    .font(.system(size: 18, weight: .semibold))
                Text(data.cardCompany ?? "")
                    .foregroundColor(Colors.color_white.color)
                    .font(.system(size: 18, weight: .semibold))
            }.padding(EdgeInsets(top: 0, leading: 40, bottom: 40, trailing: 40))
                .frame(
                      minWidth: 0,
                      maxWidth: .infinity,
                      minHeight: 0,
                      maxHeight: .infinity,
                      alignment: .bottomLeading
                    )
            if let card = cardDetail {
                VStack {
                    HStack(alignment: .top) {
                        Spacer()
                        VStack(alignment: .trailing, spacing: 5) {
                            Text("₺" + String(card.balanceAmount ?? 0.0))
                                .foregroundColor(Colors.color_accent.color)
                                .font(.system(size: 20, weight: .bold))
                                .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                        }
                        .background(Colors.color_bg.color)
                        .cornerRadius(10)
                        .padding(EdgeInsets(top: 50, leading: 40, bottom: 0, trailing: 40))
                    }
                    Spacer()
                }
            } else if data.isSelected ?? false {
                VStack {
                    HStack(alignment: .top) {
                        Spacer()
                        VStack(alignment: .trailing, spacing: 5) {
                            Image(systemName: "checkmark.circle.fill")
                                .frame(width: 20, height: 20)
                                .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                                .foregroundColor(Colors.color_primary.color)
                        }
                        .background(Colors.color_bg.color)
                        .cornerRadius(10)
                        .padding(EdgeInsets(top: 45, leading: 40, bottom: 0, trailing: 40))
                    }
                    Spacer()
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
