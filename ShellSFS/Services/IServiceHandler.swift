//
//  IServiceHandler.swift
//  ShellSFS
//
//  Created by Kagan Girgin on 5/21/23.
//

import Alamofire

protocol IServiceHandler {
    func getToken(successCompletion: @escaping(TokenResponseModel) -> Void, errorCompletion: @escaping(BaseErrorModel) -> Void)
    
    func postBalanceInquiry(params: TokenResponseModel, successCompletion: @escaping(CardDetailResponseModel) -> Void, errorCompletion: @escaping(BaseErrorModel) -> Void)
}
