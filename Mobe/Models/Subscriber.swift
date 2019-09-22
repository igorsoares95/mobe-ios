//
//  Subscriber.swift
//  Ebooks
//
//  Created by Renan Kosicki on 13/03/19.
//  Copyright © 2019 Gold360. All rights reserved.
//

import Foundation

class Subscriber: NSObject, NSCoding, Codable {
  var id: Int?
  var token: String?
  var cpf: String?
  var msisdn: Int64?
  var email: String?
  var name: String?
  
  enum CodingKeys: String, CodingKey {
    case id, token, cpf, msisdn, email, name
  }
  
  override init() {}

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    id = aDecoder.decodeObject(forKey: "id") as? Int
    name = aDecoder.decodeObject(forKey: "name") as? String
    email = aDecoder.decodeObject(forKey: "email") as? String
    cpf = aDecoder.decodeObject(forKey: "cpf") as? String
    token = aDecoder.decodeObject(forKey: "token") as? String
    msisdn = aDecoder.decodeObject(forKey: "msisdn") as? Int64
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(id, forKey: "id")
    aCoder.encode(name, forKey: "name")
    aCoder.encode(email, forKey: "email")
    aCoder.encode(msisdn, forKey: "msisdn")
    aCoder.encode(cpf, forKey: "cpf")
    aCoder.encode(token, forKey: "token")
  }

  public static func loadSubscriber() -> Subscriber? {
    let userDefaults = UserDefaults.standard
    guard let decoded  = userDefaults.object(forKey: UserDefaults.Keys.subscriber) as? Data else { return nil }
    guard let decodedUser  = NSKeyedUnarchiver.unarchiveObject(with: decoded) as? Subscriber else { return nil }
    return decodedUser
  }
  
  public static func isLogged() -> Bool {
    guard (loadSubscriber()?.token) != nil else { return false }
    return true
  }
  
  public static func remove() {
    UserDefaults.standard.removeObject(forKey: UserDefaults.Keys.subscriber)
    UserDefaults.standard.synchronize()
  }
  
  public static func save(subscriber: Subscriber) {
    let userDefaults = UserDefaults.standard
    let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: subscriber)
    userDefaults.set(encodedData, forKey: UserDefaults.Keys.subscriber)
    userDefaults.synchronize()
  }
  
}

extension UserDefaults {
  struct Keys {
    static let subscriber  = "subscriber"
  }
}
