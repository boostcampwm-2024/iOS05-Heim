//
//  GeminiEnvironment.swift
//  DataModule
//
//  Created by 정지용 on 11/13/24.
//

import Foundation

enum GeminiEnvironment {
  private static let frameworkBundle = Bundle(identifier: "kr.codesquad.boostcamp9.Heim.DataModule")
  
  static let apiKey = {
    guard let frameworkBundle,
          let apiKey = frameworkBundle.infoDictionary?["GEMINI_API_KEY"] as? String else {
      fatalError("Can't load environment: GEMINI_API_KEY")
    }
    return apiKey
  }()
  
  static let baseURL = {
    guard let frameworkBundle else {
      fatalError("Can't load environment: GEMINI_API_BASE_URL")
    }
    
    guard let baseURL = frameworkBundle.infoDictionary?["GEMINI_API_BASE_URL"] as? String else {
      fatalError("Can't load environment: GEMINI_API_BASE_URL")
    }
    return baseURL
  }()
  
  static let model = {
    guard let frameworkBundle,
          let model = frameworkBundle.infoDictionary?["GEMINI_MODEL"] as? String else {
      fatalError("Can't load environment: GEMINI_MODEL")
    }
    return model
  }()
}
