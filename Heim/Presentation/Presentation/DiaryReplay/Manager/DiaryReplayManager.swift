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
  
  func calculateMaxDecibel(completion: @escaping (Float?) -> Void) {
    guard let audioFileURL,
          let reader = createAssetReader(for: audioFileURL),
          let output = reader.outputs.first as? AVAssetReaderTrackOutput else {
      completion(nil)
      return
    }
    
    do {
      let maxDecibel = try calculateMaxDecibel(with: reader, output: output)
      completion(maxDecibel)
    } catch {
      completion(nil)
    }
  }
  
  private func createAssetReader(for url: URL) -> AVAssetReader? {
    let asset = AVURLAsset(url: url)
    guard let track = asset.tracks(withMediaType: .audio).first else { return nil }
    
    do {
      let reader = try AVAssetReader(asset: asset)
      let settings: [String: Any] = [
        AVFormatIDKey: kAudioFormatLinearPCM,
        AVSampleRateKey: 44100,
        AVLinearPCMBitDepthKey: 16,
        AVLinearPCMIsNonInterleaved: false,
        AVLinearPCMIsFloatKey: false,
        AVLinearPCMIsBigEndianKey: false
      ]
      let output = AVAssetReaderTrackOutput(track: track, outputSettings: settings)
      reader.add(output)
      return reader
    } catch {
      return nil
    }
  }
  
  private func calculateMaxDecibel(with reader: AVAssetReader, output: AVAssetReaderTrackOutput) throws -> Float {
    reader.startReading()
    
    var maxAmplitude: Float = -160.0
    while let sampleBuffer = output.copyNextSampleBuffer() {
      if let blockBuffer = CMSampleBufferGetDataBuffer(sampleBuffer) {
        maxAmplitude = max(maxAmplitude, processBlockBuffer(blockBuffer))
      }
    }
    return maxAmplitude
  }
  
  private func processBlockBuffer(_ blockBuffer: CMBlockBuffer) -> Float {
    let length = CMBlockBufferGetDataLength(blockBuffer)
    var data = [Int16](repeating: 0, count: length / MemoryLayout<Int16>.size)
    CMBlockBufferCopyDataBytes(blockBuffer, atOffset: 0, dataLength: length, destination: &data)
    
    var maxDecibel: Float = -160.0
    for sample in data {
      let amplitude = Float(sample) / Float(Int16.max)
      let decibel = 20 * log10(abs(amplitude))
      maxDecibel = max(maxDecibel, decibel)
    }
    
    return maxDecibel
  }
  
  private func formatTimeIntervalToMMSS(_ time: TimeInterval) -> String {
    let minutes = Int(time) / 60
    let seconds = Int(time) % 60
    return String(format: "%02d:%02d", minutes, seconds)
  }
}
