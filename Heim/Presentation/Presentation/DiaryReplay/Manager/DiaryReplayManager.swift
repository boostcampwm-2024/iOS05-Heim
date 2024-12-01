//
//  DiaryReplayManager.swift
//  Presentation
//
//  Created by 정지용 on 11/28/24.
//

import AVFoundation

final class DiaryReplayManager: NSObject, AVAudioPlayerDelegate {
  let audioPlayer: AVAudioPlayer
  var onPlaybackFinished: (() -> Void)?
  
  init(data: Data) throws {
    self.audioPlayer = try AVAudioPlayer(data: data)
    super.init()
    self.audioPlayer.isMeteringEnabled = true
    self.audioPlayer.delegate = self
  }
  
  var currentTime: String {
    return formatTimeIntervalToMMSS(audioPlayer.currentTime)
  }
  
  func play() async {
    audioPlayer.prepareToPlay()
    audioPlayer.play()
  }
  
  func pause() {
    audioPlayer.pause()
  }
  
  func reset() {
    audioPlayer.currentTime = 0
    audioPlayer.stop()
  }
  
  func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
    onPlaybackFinished?()
  }
  
  private func formatTimeIntervalToMMSS(_ time: TimeInterval) -> String {
    let minutes = Int(time) / 60
    let seconds = Int(time) % 60
    return String(format: "%02d:%02d", minutes, seconds)
  }
}
