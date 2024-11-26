//
//  MusicRepository.swift
//  Domain
//
//  Created by 정지용 on 11/26/24.
//

public protocol MusicRepository {
  func hasMusicAccess() async throws -> Bool
  func isAppleMusicSubscribed() async throws -> Bool
  func playMusicWithMusicKit(_ isrc: String) async throws
  func playPreviewWithAVPlayer(_ isrc: String) async throws
  func pause() throws
}
