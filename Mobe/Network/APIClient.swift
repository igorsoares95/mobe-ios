//
//  APIClient.swift
//  Ebooks
//
//  Created by Renan Kosicki on 09/02/19.
//  Copyright © 2019 Gold360. All rights reserved.
//

import Alamofire
import RxSwift
import RxAlamofire

final class APIClient {

  var baseURL: String

  init(baseURL: String) {
    self.baseURL = baseURL
  }
  
  func executeRequestWithArray(endpoint: APIEndpointWithArray, completionHandler: @escaping (_ success: Bool) -> Void) {

    Alamofire.request(baseURL + endpoint.path,
                      method: endpoint.method,
                      parameters: endpoint.params?.asParameters(),
                      encoding: endpoint.encoding,
                      headers: endpoint.headers)
      .validate(statusCode: 200..<400)
      .responseData(completionHandler: { response in
        switch response.result {
        case .success:
          completionHandler(true)
        case .failure:

          if let code = response.response?.statusCode {
            if code == 401, endpoint.headers["Authorization"] != nil {
              NotificationCenter.default.post(name: NSNotification.Name(rawValue: "session_expired"), object: nil)
            }
          }

          completionHandler(false)
        }
      })
  }
  
  func execute(endpoint: APIEndpoint, completionHandler: @escaping (_ success: Bool) -> Void) {
    
    Alamofire.request(baseURL + endpoint.path,
                      method: endpoint.method,
                      parameters: endpoint.params,
                      encoding: endpoint.encoding,
                      headers: endpoint.headers)
      .validate(statusCode: 200..<400)
      .responseData(completionHandler: { response in
        switch response.result {
        case .success:
          completionHandler(true)
        case .failure:
          
          if let code = response.response?.statusCode {
            if code == 401, endpoint.headers["Authorization"] != nil {
              NotificationCenter.default.post(name: NSNotification.Name(rawValue: "session_expired"), object: nil)
            }
          }
          
          completionHandler(false)
        }
      })
  }
  
  func execute(endpoint: APIEndpoint, completionHandler: @escaping (_ success: Bool, _ code: Int) -> Void) {
    
    Alamofire.request(baseURL + endpoint.path,
                      method: endpoint.method,
                      parameters: endpoint.params,
                      encoding: endpoint.encoding,
                      headers: endpoint.headers)
      .validate(statusCode: 200..<400)
      .responseData(completionHandler: { response in
        
        guard let statusCode = response.response?.statusCode else { return }
        switch response.result {
        case .success:
          completionHandler(true, statusCode)
        case .failure:
          
          if let code = response.response?.statusCode {
            if code == 401, endpoint.headers["Authorization"] != nil {
              NotificationCenter.default.post(name: NSNotification.Name(rawValue: "session_expired"), object: nil)
            }
          }
          
          completionHandler(false, statusCode)
        }
      })
  }

  func executeStatusCode<Element: Codable>(endpoint: APIEndpoint,
                                 completionHandler: @escaping (Result<Element>, Int?) -> Void) {
    
    _ = SessionManager
      .default
      .rx
      .request(endpoint.method,
               baseURL + endpoint.path,
               parameters: endpoint.params,
               encoding: endpoint.encoding,
               headers: endpoint.headers)
      .responseData()
      .subscribe(onNext: { (response, data) in
        do {
          let decoder = JSONDecoder()
          let parsedObject = try decoder.decode(Element.self, from: data)
          return completionHandler(.success(parsedObject), response.statusCode)
        } catch let error {
          print(error)
          return completionHandler(.failure(APIClientError.parseError), response.statusCode)
        }
      }, onError: { error in
        if
          let afError = error as? AFError,
          let code = afError.responseCode,
          let endpointError = endpoint.error(forStatusCode: code) {
          
          if code == 401, endpoint.headers["Authorization"] != nil {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "session_expired"), object: nil)
          }
          
          return completionHandler(.failure(endpointError), nil)
        }

        if let urlError = error as? URLError,
          urlError.code  == .notConnectedToInternet {
          return completionHandler(.failure(APIClientError.noInternetError), nil)
        }

        if (error as NSError).code == -1004 {
          return completionHandler(.failure(APIClientError.serverIsOffline), nil)
        }

        return completionHandler(.failure(error), nil)
      })
  }
  
  func executeStatusCode<FirstElement: Codable, SecondElement: Codable>(endpoint: APIEndpoint,
                                           completionHandler: @escaping (Result<FirstElement>, Result<SecondElement>, Int?) -> Void) {
    
    _ = SessionManager
      .default
      .rx
      .request(endpoint.method,
               baseURL + endpoint.path,
               parameters: endpoint.params,
               encoding: endpoint.encoding,
               headers: endpoint.headers)
      .responseData()
      .subscribe(onNext: { (response, data) in
        let decoder = JSONDecoder()
        
        var firstState: Result<FirstElement>
        var secondState: Result<SecondElement>
        var firstParsedObject: FirstElement
        var secondParsedObject: SecondElement

        do {
          firstParsedObject = try decoder.decode(FirstElement.self, from: data)
          firstState = .success(firstParsedObject)
        } catch let error {
          print(error)
          firstState = .failure(APIClientError.parseError)
        }
        
        do {
          secondParsedObject = try decoder.decode(SecondElement.self, from: data)
          secondState = .success(secondParsedObject)
        } catch let error {
          print(error)
          secondState = .failure(APIClientError.parseError)
        }
        
        return completionHandler(firstState, secondState, response.statusCode)

      }, onError: { error in
        if
          let afError = error as? AFError,
          let code = afError.responseCode,
          let endpointError = endpoint.error(forStatusCode: code) {
          
          if code == 401, endpoint.headers["Authorization"] != nil {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "session_expired"), object: nil)
          }
          
          return completionHandler(.failure(endpointError), .failure(endpointError), nil)
        }
        
        if let urlError = error as? URLError,
          urlError.code  == .notConnectedToInternet {
          return completionHandler(.failure(APIClientError.noInternetError), .failure(APIClientError.noInternetError), nil)
        }
        
        if (error as NSError).code == -1004 {
          return completionHandler(.failure(APIClientError.serverIsOffline), .failure(APIClientError.serverIsOffline), nil)
        }
        
        return completionHandler(.failure(error), .failure(error), nil)
      })
  }

  func execute<Element: Codable>(endpoint: APIEndpoint,
                                 completionHandler: @escaping (Result<Element>) -> Void) {
    _ = SessionManager
      .default
      .rx
      .request(endpoint.method,
               baseURL + endpoint.path,
               parameters: endpoint.params,
               encoding: endpoint.encoding,
               headers: endpoint.headers)
      .validate(statusCode: 200 ..< 400)
      .validate(contentType: ["application/json"])
      .responseData()
      .subscribe(onNext: { (response, data) in
        do {
          let decoder = JSONDecoder()
          
          decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
          
          let parsedObject = try decoder.decode(Element.self, from: data)
          return completionHandler(.success(parsedObject))
        } catch let error {
          print(error)
          return completionHandler(.failure(APIClientError.parseError))
        }
      }, onError: { error in
        if
          let afError = error as? AFError,
          let code = afError.responseCode,
          let endpointError = endpoint.error(forStatusCode: code) {
          
          if code == 401, endpoint.headers["Authorization"] != nil {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "session_expired"), object: nil)
          }
          
          return completionHandler(.failure(endpointError))
        }

        if let urlError = error as? URLError,
          urlError.code  == .notConnectedToInternet {
          return completionHandler(.failure(APIClientError.noInternetError))
        }

        if (error as NSError).code == -1004 {
          return completionHandler(.failure(APIClientError.serverIsOffline))
        }

        return completionHandler(.failure(error))
      })
  }
}
