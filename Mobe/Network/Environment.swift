//
//  Environment.swift
//  Ebooks
//
//  Created by Renan Kosicki on 09/02/19.
//  Copyright © 2019 Gold360. All rights reserved.
//

import Foundation

struct Environment {
	fileprivate static func getEnvironmentVariables () -> [String:AnyObject]?{
		return  Bundle.main.infoDictionary?["Environment"] as? [String:AnyObject]
	}
	
	static func getBaseApiUrl() -> String {
		guard let url = self.getEnvironmentVariables()?["base_url"] as? String else {
			return ""
		}
		return url
	}
  
  static func getBaseApiUrlImages() -> String {
    guard let url = self.getEnvironmentVariables()?["image_url"] as? String else {
      return ""
    }
    return url
  }
}
