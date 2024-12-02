//
//  AVPlayerManager.swift
//  DataModule
//
//  Created by 정지용 on 11/26/24.
//

import AVFoundation
import MusicKit

final class AVPlayerManager {
  private var player: AVPlayer?
  
  var isPlaying: Bool {
    return player?.timeControlStatus == .playing
  }
  
  func play(url: URL) async {
    player = AVPlayer(url: url)
    await player?.play()
  }
  
  func pause() {
    player?.pause()
  }
}
