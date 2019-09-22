//
//  RegisterEndpoint.swift
//  Skeelo
//
//  Created by Igor Soares on 20/03/19.
//  Copyright © 2019 Gold360. All rights reserved.
//

import Alamofire

enum RegisterError: Error {
  case defaultError
  
  var localizedDescription: String {
    switch self {
    case .defaultError:
      return "Infelizmente houve um error no registro, tente novamente mais tarde"
    }
  }
}

class RegisterEndpoint: APIEndpoint {
  
  var path: String = "/subscriber"
  var headers: [String : String] = APIHeaders.headers()
  var params: [String : Any]?
  var method: HTTPMethod = .post
  var encoding: ParameterEncoding = JSONEncoding.default
  
  func error(forStatusCode code: Int) -> Error? {
    switch code {
    default:
      return RegisterError.defaultError
    }
  }
  
  init(name: String, email: String, telephone: String, password: String) {
    params = [
      "name": name, "email": email, "telephone": telephone, "password": password
    ]
  }
}
