//
//  TokenError.swift
//  Domain
//
//  Created by 정지용 on 11/27/24.
//

public enum TokenError: Error {
  case accessTokenExpired
  case refreshTokenExpired
  
  public var description: String {
    switch self {
    case .accessTokenExpired:
      return "만료된 AccessToken"
    case .refreshTokenExpired:
      return "만료된 RefreshToken"
    }
  }
}
