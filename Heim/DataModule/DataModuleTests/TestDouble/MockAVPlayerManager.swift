//
//  MockAVPlayerManager.swift
//  DataModuleTests
//
//  Created by 정지용 on 12/5/24.
//

import Foundation
@testable import DataModule

final class MockAVPlayerManager: AVPlayerManager {
  struct CallCount {
    var play = 0
    var pause = 0
    var setVolume = 0
    var setupAudioSession = 0
  }
  
  var callCount = CallCount()
  var isPlaying: Bool = false
  
  func play(url: URL) async {
    callCount.play += 1
  }
  
  func pause() {
    callCount.pause += 1
  }
  
  func setVolume(_ volume: Float) {
    callCount.setVolume += 1
  }
  
  func setupAudioSession() throws {
    callCount.setupAudioSession += 1
  }
}
