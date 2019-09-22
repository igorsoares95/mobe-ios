//
//  APIEndpoint.swift
//  Ebooks
//
//  Created by Renan Kosicki on 09/02/19.
//  Copyright © 2019 Gold360. All rights reserved.
//

import Alamofire

protocol APIEndpoint {
	
	var path: String { get }
	var params: [String: Any]? { get }
	var headers: [String: String] { get }
	var method: HTTPMethod { get }
	var encoding: ParameterEncoding { get }
	
	func error(forStatusCode code: Int) -> Error?
}

protocol APIEndpointWithArray {
  
  var path: String { get }
  var params: [Any]? { get }
  var headers: [String: String] { get }
  var method: HTTPMethod { get }
  var encoding: ParameterEncoding { get }
  
  func error(forStatusCode code: Int) -> Error?
}
