//
//  MusicUseCase.swift
//  Domain
//
//  Created by 정지용 on 11/25/24.
//

import Foundation

public protocol MusicUseCase {
  func fetchRecommendTracks(_ emotion: Emotion) async throws -> [Track]
  func play(to isrc: String)
}

public struct DefaultMusicUseCase: MusicUseCase {
  private let repository: SpotifyRepository
  
  public init(repository: SpotifyRepository) {
    self.repository = repository
  }
  
  public func fetchRecommendTracks(_ emotion: Emotion) async throws -> [Track] {
    return try await repository.fetchRecommendationTrack(emotion)
  }
  
  // TODO: MusicKit 연동 후 구현
  public func play(to isrc: String) {
    
  }
}
