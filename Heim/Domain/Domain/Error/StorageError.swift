//
//  StorageError.swift
//  Domain
//
//  Created by 정지용 on 11/19/24.
//

public enum StorageError: Error {
  case readError
  case writeError
  case deleteError
  case invalidInput // TimeStamp로 invalidate한 값이 들어오는 경우
  
  public var description: String {
    switch self {
    case .readError: return "파일 읽기 중 오류 발생"
    case .writeError: return "파일 쓰기 중 오류 발생"
    case .deleteError: return "파일 삭제 중 오류 발생"
    case .invalidInput: return "파일 입력 오류 발생"
    }
  }
}
