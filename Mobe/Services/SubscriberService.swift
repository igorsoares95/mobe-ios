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

  func login(email: String, password: String, regId: String,
             completionHandler: @escaping (Result<Subscriber>) -> Void) {
    apiClient.execute(endpoint: LoginEndpoint(email: email, password: password, regId: regId),
                      completionHandler: completionHandler)
  }
  
  func register(name: String,
                          email: String,
                          telephone: String,
                          password: String,
                          completionHandler: @escaping (Result<Subscriber>) -> Void) {
    apiClient.execute(endpoint: RegisterEndpoint(name: name,
                                                 email: email,
                                                 telephone: telephone,
                                                 password: password),
                      completionHandler: completionHandler)
  }
}
