//
//  SpotifyEnvironment.swift
//  DataModule
//
//  Created by 정지용 on 11/13/24.
//

import Foundation

public enum SpotifyEnvironment {
  private static let frameworkBundle = Bundle(identifier: "kr.codesquad.boostcamp9.Heim.DataModule")
  
  public static let clientId = {
    guard let frameworkBundle,
          let clientId = frameworkBundle.infoDictionary?["SPOTIFY_CLIENT_ID"] as? String else {
      fatalError("Can't load environment: SPOTIFY_CLIENT_ID")
    }
    return clientId
  }()
  
  static let oauthBaseURL = {
    guard let frameworkBundle,
          let oauthBaseURL = frameworkBundle.infoDictionary?["SPOTIFY_OAUTH_BASE_URL"] as? String else {
      fatalError("Can't load environment: SPOTIFY_OAUTH_BASE_URL")
    }
    return oauthBaseURL
  }()
  
  static let apiBaseURL = {
    guard let frameworkBundle,
          let apiBaseURL = frameworkBundle.infoDictionary?["SPOTIFY_API_BASE_URL"] as? String else {
      fatalError("Can't load environment: SPOTIFY_API_BASE_URL")
    }
    return apiBaseURL
  }()
  
  static let redirectURI: String = "Heim://spotifyLogin"
  static let accessTokenAttributeKey: String = "a3f24f4a11fd0135627ddd8ab9f40cbe"
  static let refreshTokenAttributeKey: String = "65f9c2d174ff38ead38339d7dec2389c"
  static let expiresInAttributeKey: String = "b2edc2b5147c0583265864cd99931fb2"
}
