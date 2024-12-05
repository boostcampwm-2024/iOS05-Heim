//
//  DefaultMusicRepository.swift
//  DataModule
//
//  Created by 정지용 on 11/26/24.
//

import AVFoundation
import Domain
import MusicKit

public struct DefaultMusicRepository: MusicRepository {
  private var musicKitPlayer = ApplicationMusicPlayer.shared
  private var avPlayerManager: AVPlayerManager
  
  public init(avPlayerManager: AVPlayerManager) {
    self.avPlayerManager = avPlayerManager
  }
  
  public func hasMusicAccess() async throws -> Bool {
    let status = await MusicAuthorization.request()
    return status == .authorized
  }
  
  public func isAppleMusicSubscribed() async throws -> Bool {
    let subscription = try await MusicSubscription.current
    return subscription.canPlayCatalogContent
  }
  
  public func playMusicWithMusicKit(_ isrc: String) async throws {
    let request = MusicCatalogResourceRequest<Song>(matching: \.isrc, equalTo: isrc)
    let searchResponse = try await request.response()
    guard let song = searchResponse.items.first else { return }
    musicKitPlayer.queue = [song]
    try await musicKitPlayer.prepareToPlay()
    try await musicKitPlayer.play()
  }
  
  public func playPreviewWithAVPlayer(_ isrc: String) async throws {
    // 0. AudioSession 설정
    try avPlayerManager.setupAudioSession()
    
    // 1. ISRC로 곡 검색
    let request = MusicCatalogResourceRequest<Song>(matching: \.isrc, equalTo: isrc)
    let searchResponse = try await request.response()

    guard let song = searchResponse.items.first else {
      throw MusicError.invalidURL
    }

    // 2. 미리듣기 URL 확인
    guard let previewURL = song.previewAssets?.first?.url else {
      throw MusicError.invalidURL
    }

    // 3. AVPlayer로 재생
    await avPlayerManager.play(url: previewURL)
  }

  public func pause() throws {
    if musicKitPlayer.state.playbackStatus == .playing {
      musicKitPlayer.pause()
    } else if avPlayerManager.isPlaying {
      avPlayerManager.pause()
    } else {
      throw MusicError.playingError
    }
  }
}
