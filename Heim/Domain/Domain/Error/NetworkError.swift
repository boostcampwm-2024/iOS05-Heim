//
//  NetworkError.swift
//  Domain
//
//  Created by 정지용 on 11/19/24.
//

public enum NetworkError: Error {
  case clientError
  case serverError
  case invalidURL
  
  public var description: String {
    switch self {
    case .clientError:
      return "잘못된 요청"
    case .serverError:
      return "네트워크 요청 실패"
    case .invalidURL:
      return "잘못된 URL"
    }
  }
}
