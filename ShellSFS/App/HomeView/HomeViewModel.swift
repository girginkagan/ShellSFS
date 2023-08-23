//
//  HomeViewModel.swift
//  ShellSFS
//
//  Created by Kagan Girgin on 5/20/23.
//

import Foundation
import Combine

final class HomeViewModel: ObservableObject {
    private let services = RestClient()
    private let realmUtil = RealmUtil()
    var cancellables = Set<AnyCancellable>()
    let cardData = CurrentValueSubject<CardDetailResponseModel?, Never>(nil)
    let onProgressVisibilityChanged = CurrentValueSubject<Bool, Never>(false)
    @Published var isAlert: BaseErrorModel?
    
    func getSelectedCard(progress: Bool = true) -> CardResponseModel? {
        if progress {
            onProgressVisibilityChanged.send(true)
        }
        let data = DataProvider.shared.cards.value.first(where: {$0.isSelected ?? false})
        if data == nil {
            onProgressVisibilityChanged.send(false)
        }
        
        return data
    }
    
    func getCardDetail() {
        services.getToken { [weak self] success in
            self?.getBalance(params: success)
        } errorCompletion: { [weak self] error in
            self?.onProgressVisibilityChanged.send(false)
            self?.isAlert = error
        }
    }
    
    private func getBalance(params: TokenResponseModel) {
        services.postBalanceInquiry(params: params) { [weak self] success in
            self?.cardData.send(CardDetailResponseModel(balanceAmount: success.balanceAmount, cardStatusName: success.cardStatusName, message: nil))
            self?.onProgressVisibilityChanged.send(false)
        } errorCompletion: { [weak self] error in
            self?.onProgressVisibilityChanged.send(false)
            self?.isAlert = error
        }
    }
}
