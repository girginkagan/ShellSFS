//
//  RestClient.swift
//  ShellSFS
//
//  Created by Kagan Girgin on 5/21/23.
//

import Alamofire
import SwiftSoup
import Vision
import UIKit

public class RestClient: IServiceHandler {
    
    static let sharedInstance = RestClient()
    var session: Session
    
    init() {
        let configuration = URLSessionConfiguration.af.default
        session = Session(configuration: configuration)
    }
    
    private func sendRequest<T: Codable>(_ request: BaseRequest, _ type: T.Type, successCompletion: @escaping(T) -> Void, errorCompletion:  @escaping(BaseErrorModel) -> Void) {
        AF.request(request.request()).responseDecodable { (response: AFDataResponse<T>) in
            switch response.result {
            case .success(let json):
                if response.response!.statusCode == APIStatusCodes.success.rawValue {
                    successCompletion(json)
                } else {
                    print(response.result)
                    errorCompletion(BaseErrorModel(errorCode: response.response!.statusCode, message: "An unknown error has occured.", errors: nil))
                }
            case .failure(let error):
                errorCompletion(BaseErrorModel(errorCode: nil, message: error.localizedDescription, errors: nil))
                print(error.localizedDescription)
            }
        }
    }
    
    private func sendStringRequest(_ request: BaseRequest, successCompletion: @escaping(_ data: String) -> Void, errorCompletion:  @escaping(BaseErrorModel) -> Void) {
        AF.request(request.request()).responseString { response in
            switch response.result {
            case .success(let json):
                if response.response!.statusCode == APIStatusCodes.success.rawValue {
                    successCompletion(json)
                } else {
                    print(response.result)
                    errorCompletion(BaseErrorModel(errorCode: response.response!.statusCode, message: "An unknown error has occured.", errors: nil))
                }
            case .failure(let error):
                errorCompletion(BaseErrorModel(errorCode: nil, message: error.localizedDescription, errors: nil))
                print(error.localizedDescription)
            }
        }
    }
    
    func getToken(successCompletion: @escaping (TokenResponseModel) -> Void, errorCompletion: @escaping (BaseErrorModel) -> Void) {
        let request = GetTokenApiRequest()
        session.request(request.baseUrl + request.requestPath, method: .get, parameters: nil, encoding: URLEncoding.default, headers: ["User-Agent": "PostmanRuntime/7.28.4", "Accept": "*/*", "Accept-Encoding": "gzip, deflate, br", "Connection": "keep-alive"]).responseString { response in
            switch response.result {
            case .success(let data):
                if let fields = response.response?.allHeaderFields as? [String : String]{
                    self.session.sessionConfiguration.httpCookieStorage = HTTPCookieStorage()
                    self.session.sessionConfiguration.httpCookieStorage?.setCookies(HTTPCookie.cookies(withResponseHeaderFields: fields, for: (response.request?.url!)!), for: URL(string: request.baseUrl + "account/balanceinquiry"), mainDocumentURL: URL(string: request.baseUrl + "account/balanceinquiry"))
                }
                
                if response.response!.statusCode == APIStatusCodes.success.rawValue {
                    let doc = try? SwiftSoup.parse(data)
                    var captcha = "https://sfs.turkiyeshell.com"
                    var captchaText = ""
                    var captchaToken = ""
                    
                    let inputArray = try? doc?.select("input").array()
                    for item in inputArray ?? [] {
                        if (try? item.attr("name")) == "DNTCaptchaText" {
                            captchaText = (try? item.attr("value")) ?? ""
                        } else if (try? item.attr("name")) == "DNTCaptchaToken" {
                            captchaToken = (try? item.attr("value")) ?? ""
                        }
                    }
                    
                    let imgArray = try? doc?.select("img").array()
                    for item in imgArray ?? [] {
                        if (try? item.attr("name")) == "SFSOnehubCaptchaImg" {
                            captcha += (try? item.attr("src")) ?? ""
                        }
                    }
                    let cardNumber = DataProvider.shared.cards.value.first(where: {$0.isSelected ?? false})?.cardNumber ?? ""
                    
                    self.getCaptchaText(model: TokenResponseModel(cardNumber: cardNumber, dntCaptchaText: captchaText, dntCaptchaToken: captchaToken, dntCaptchaInput: captcha), successCompletion: successCompletion, errorCompletion: errorCompletion)
                } else {
                    print(response.result)
                    errorCompletion(BaseErrorModel(errorCode: response.response!.statusCode, message: "An unknown error has occured.", errors: nil))
                }
            case .failure(let error):
                errorCompletion(BaseErrorModel(errorCode: nil, message: error.localizedDescription, errors: nil))
                print(error.localizedDescription)
            }
        }
    }
    
    func postBalanceInquiry(params: TokenResponseModel, successCompletion: @escaping (CardDetailResponseModel) -> Void, errorCompletion: @escaping (BaseErrorModel) -> Void) {
        let request = PostBalanceInquiryApiRequest(params: params)
        session.request(request.baseUrl + request.requestPath, method: .post, parameters: params).responseDecodable { (response: DataResponse<CardDetailResponseModel, AFError>) in
            switch response.result {
            case .success(let json):
                if response.response!.statusCode == APIStatusCodes.success.rawValue {
                    successCompletion(json)
                } else {
                    print(response.result)
                    errorCompletion(BaseErrorModel(errorCode: response.response!.statusCode, message: "An unknown error has occured.", errors: nil))
                }
            case .failure(let error):
                errorCompletion(BaseErrorModel(errorCode: nil, message: error.localizedDescription, errors: nil))
                print(error.localizedDescription)
            }
        }
    }
}

extension RestClient {
    func getCaptchaText(model: TokenResponseModel, successCompletion: @escaping (TokenResponseModel) -> Void, errorCompletion: @escaping (BaseErrorModel) -> Void) {
        session.request(model.dntCaptchaInput ?? "", method: .get, parameters: nil, encoding: URLEncoding.default, headers: ["User-Agent": "PostmanRuntime/7.28.4", "Accept": "*/*", "Accept-Encoding": "gzip, deflate, br", "Connection": "keep-alive"]).responseData { response in
            switch response.result {
            case .success(let data):
                if response.response!.statusCode == APIStatusCodes.success.rawValue {
                    let cgImage = UIImage(data: data)?.cgImage
                    if let cgImage = cgImage {
                        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
                        let request = VNRecognizeTextRequest { request, error in
                            guard let observations = request.results as? [VNRecognizedTextObservation],
                                  error == nil else { return }
                            let captcha = observations.compactMap({
                                $0.topCandidates(1).first?.string
                            }).joined(separator: ", ")
                            successCompletion(TokenResponseModel(cardNumber: model.cardNumber, dntCaptchaText: model.dntCaptchaText, dntCaptchaToken: model.dntCaptchaToken, dntCaptchaInput: captcha))
                        }
                        
                        request.recognitionLevel = .accurate
                        try? handler.perform([request])
                    }
                } else {
                    print(response.result)
                    errorCompletion(BaseErrorModel(errorCode: response.response!.statusCode, message: "An unknown error has occured.", errors: nil))
                }
            case .failure(let error):
                errorCompletion(BaseErrorModel(errorCode: nil, message: error.localizedDescription, errors: nil))
                print(error.localizedDescription)
            }
        }
    }
}
