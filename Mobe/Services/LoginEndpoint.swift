//
//  LoginEndpoint.swift
//  Ebooks
//
//  Created by Renan Kosicki on 19/02/19.
//  Copyright © 2019 Gold360. All rights reserved.
//

import Alamofire

enum LoginError: Error {
  case defaultError

  var localizedDescription: String {
    switch self {
    case .defaultError:
      return "Infelizmente houve um erro no login, tente novamente mais tarde"
    }
  }
}

class LoginEndpoint: APIEndpoint {
	
  var path: String = "/login.php"
  var headers: [String: String] = APIHeaders.headers()
  var params: [String : Any]?
  var method: HTTPMethod  = .post
  var encoding: ParameterEncoding = JSONEncoding.default

  func error(forStatusCode code: Int) -> Error? {
    switch code {
    default:
      return LoginError.defaultError
    }
  }
	
  init(email: String, password: String, regId: String) {
    params = [
      "email": email, "senha": password, "reg_id": regId
    ]
  }
}
