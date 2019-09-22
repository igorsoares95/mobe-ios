//
//  APIClientError.swift
//  Ebooks
//
//  Created by Renan Kosicki on 09/02/19.
//  Copyright © 2019 Gold360. All rights reserved.
//

import Foundation

enum APIClientError: Error {
  case noInternetError
  case parseError
  case serverIsOffline
  
  var localizedDescription: String {
    switch self {
    case .noInternetError:
      return "Sem conexão com a internet"
    case .parseError:
      return "Erro de conversão da api"
    case .serverIsOffline:
      return "A api está offline"
    }
  }
}
