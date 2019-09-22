//
//  APIHeaders.swift
//  Ebooks
//
//  Created by Renan Kosicki on 09/02/19.
//  Copyright © 2019 Gold360. All rights reserved.
//

import Foundation
import Alamofire

class APIHeaders {
  class func headers() -> [String: String] {
    var headers = [String: String]()

    headers["Accept"] = "application/json"
    headers["accept-encoding"] = "*"
    
//    let subscriber = Subscriber.loadSubscriber()
//    if let token = subscriber?.token, !token.isEmpty {
//      headers["Authorization"] = "Bearer \(token)"
//    }
    
    if let defaultUserAgent = Alamofire.SessionManager.defaultHTTPHeaders["User-Agent"] {
      headers["User-Agent"] = "\(defaultUserAgent) (\(DeviceType.current))"
    }
    
    return headers
  }
}
