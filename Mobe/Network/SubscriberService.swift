//
//  SubscriberService.swift
//  Ebooks
//
//  Created by Renan Kosicki on 19/02/19.
//  Copyright © 2019 Gold360. All rights reserved.
//

import Alamofire

class SubscriberService {

  let apiClient = APIClient(baseURL: Environment.getBaseApiUrl())

//  func login(msisdn: Int64, password: String,
//             completionHandler: @escaping (Result<Subscriber>) -> Void) {
//    apiClient.execute(endpoint: LoginEndpoint(msisdn: msisdn, password: password),
//                      completionHandler: completionHandler)
//  }
//  
//  func register(msisdn: Int64,
//                          name: String,
//                          email: String,
//                          cpf: String,
//                          password: String,
//                          giftCode: String?,
//                          completionHandler: @escaping (Result<Subscriber>) -> Void) {
//    apiClient.execute(endpoint: RegisterEndpoint(msisdn: msisdn,
//                                                         email: email,
//                                                         cpf: cpf,
//                                                         password: password,
//                                                         name: name,
//                                                         giftCode: giftCode),
//                      completionHandler: completionHandler)
//  }
}
