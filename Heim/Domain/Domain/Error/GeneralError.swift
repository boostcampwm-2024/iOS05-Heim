//
//  GeneralError.swift
//  Domain
//
//  Created by 정지용 on 11/19/24.
//

enum GeneralError: Error {
  case environmentError
  
  var description: String {
    switch self {
    case .environmentError:
      return "환경변수 불러오기 실패"
    }
  }
}
