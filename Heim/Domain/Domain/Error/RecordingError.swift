//
//  RecordingError.swift
//  Domain
//
//  Created by 정지용 on 11/19/24.
//

public enum RecordingError: Error {
  case permissionError
  case audioError
  
  public var description: String {
    switch self {
    case .permissionError:
      return "사용자 권한 오류"
    case .audioError:
      return "음성 녹음 중 오류"
    }
  }
}
