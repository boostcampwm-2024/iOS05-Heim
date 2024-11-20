//
//  JSONError.swift
//  Domain
//
//  Created by 정지용 on 11/19/24.
//

public enum JSONError: Error {
  case decodingError
  case encodingError
  
  public var description: String {
    switch self {
    case .decodingError: return "파싱 중 오류 발생"
    case .encodingError: return "파싱 중 오류 발생"
    }
  }
}
