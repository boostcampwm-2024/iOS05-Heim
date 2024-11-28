//
//  MusicUseCase.swift
//  Domain
//
//  Created by 정지용 on 11/25/24.
//

import Foundation

public protocol MusicUseCase {
  func fetchRecommendTracks(_ emotion: Emotion) async throws -> [Track]
  func play(to isrc: String) async throws
  func pause() throws
}

public struct DefaultMusicUseCase: MusicUseCase {
  private let spotifyRepository: SpotifyRepository
  private let musicRepository: MusicRepository
  
  public init(
    spotifyRepository: SpotifyRepository,
    musicRepository: MusicRepository
  ) {
    self.spotifyRepository = spotifyRepository
    self.musicRepository = musicRepository
  }
  
  public func fetchRecommendTracks(_ emotion: Emotion) async throws -> [Track] {
    return try await spotifyRepository.fetchRecommendationTrack(emotion)
  }
  
  public func play(to isrc: String) async throws {
    guard try await musicRepository.hasMusicAccess() else { throw MusicError.accessDenied }
    if try await musicRepository.isAppleMusicSubscribed() {
      try await musicRepository.playMusicWithMusicKit(isrc)
    } else {
      try await musicRepository.playPreviewWithAVPlayer(isrc)
    }
  }
  
  public func pause() throws {
    try musicRepository.pause()
  }
}
