//
//  IOError.swift
//  Domain
//
//  Created by 정지용 on 11/19/24.
//

public enum IOError: Error {
  case readError
  case writeError
  
  public var description: String {
    switch self {
    case .readError: return "파일 읽기 중 오류 발생"
    case .writeError: return "파일 쓰기 중 오류 발생"
    }
  }
}
