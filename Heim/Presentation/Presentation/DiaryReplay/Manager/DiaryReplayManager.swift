//
//  DiaryReplayManager.swift
//  Presentation
//
//  Created by 정지용 on 11/28/24.
//

import AVFoundation
import Domain

final class DiaryReplayManager: NSObject, AVAudioPlayerDelegate {
  let audioPlayer: AVAudioPlayer
  var onPlaybackFinished: (() -> Void)?
  private(set) var audioFileURL: URL?
  private var tmpFilePath: URL?
  
  init(data: Data) throws {
    // 1. 오디오 세션 설정
    let audioSession = AVAudioSession.sharedInstance()
    try audioSession.setCategory(.playback, mode: .default)
    try audioSession.setActive(true)
    
    do {
      // 2. 임시 파일로 저장 후 URL로 초기화
      let tempDir = FileManager.default.temporaryDirectory
      let tempFile = tempDir.appendingPathComponent(UUID().uuidString + ".wav")
      try data.write(to: tempFile)
      
      // 3. URL로 플레이어 초기화
      self.audioFileURL = tempFile
      self.audioPlayer = try AVAudioPlayer(contentsOf: tempFile)
      super.init()
      
      // 4. 설정 및 준비
      self.audioPlayer.isMeteringEnabled = true
      self.audioPlayer.delegate = self
      self.audioPlayer.prepareToPlay()
      
    } catch {
      throw NSError()
    }
  }
  
  deinit {
    guard let path = tmpFilePath else { return }
    try? FileManager.default.removeItem(at: path)
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
