//
//  MusicError.swift
//  Domain
//
//  Created by 정지용 on 11/26/24.
//

public enum MusicError: Error {
  case accessDenied
  case invalidURL
  case playingError
  
  var description: String {
    switch self {
    case .accessDenied: return "Apple Music 접근 권한 없음"
    case .invalidURL: return "유효하지 않은 ISRC URL"
    case .playingError: return "재생중 오류 발생"
    }
  }
}
