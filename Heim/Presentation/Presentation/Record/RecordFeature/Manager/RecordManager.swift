//
//  RecordManager.swift
//  Presentation
//
//  Created by 박성근 on 11/18/24.
//

import AVFoundation
import Domain
import UIKit
import Speech

final class RecordManager {
  // MARK: - 음성 인식을 위한 Properties
  private let speechRecognizer: SFSpeechRecognizer
  private let audioEngine: AVAudioEngine
  private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
  private var recognitionTask: SFSpeechRecognitionTask?
  
  // MARK: - 인식된 텍스트, 경과한 시간
  private(set) var recognizedText: String
  private(set) var minuteAndSeconds: Int
  
  // MARK: - 음성 녹음을 위한 Properties
  //  private var audioRecorder: AVAudioRecorder?
  private var timer: Timer?
  
  // MARK: - 음성 데이터
  private var recordingData: Data
  private(set) var voice: Voice?
  
  var formattedTime: String {
    let minutes = minuteAndSeconds / 60
    let seconds = minuteAndSeconds % 60
    return String(format: "%02d:%02d", minutes, seconds)
  }
  
  init(locale: Locale = Locale(identifier: "ko-KR")) {
    self.speechRecognizer = SFSpeechRecognizer(locale: locale)!
    self.audioEngine = AVAudioEngine()
    self.recognizedText = ""
    self.minuteAndSeconds = 0
    self.recordingData = Data()
  }
  
  // MARK: - 녹음과정 준비
  func setupSpeech() async throws {
    let authStatus = await withCheckedContinuation { continuation in
      SFSpeechRecognizer.requestAuthorization { status in
        continuation.resume(returning: status)
      }
    }
    
    switch authStatus {
    case .authorized:
      return
    case .denied, .restricted, .notDetermined:
      throw RecordingError.permissionError
    @unknown default:
      throw RecordingError.permissionError
    }
  }
  
  func startRecording() throws {
    if recognitionRequest == nil {
      // MARK: - 새로운 녹음 시작
      try setupNewRecording()
    } else {
      // MARK: - 일시중지 된 상태에서 다시 재개
      try resumeRecording()
    }
  }
  
  // MARK: - 일시중지
  func stopRecording() {
    audioEngine.pause()
    voice = Voice(audioBuffer: recordingData)
    timer?.invalidate()
    timer = nil
  }
  
  func resetAll() {
    audioEngine.stop()
    
    audioEngine.inputNode.removeTap(onBus: 0)
    
    recognitionRequest?.endAudio()
    recognitionRequest = nil
    
    recognitionTask?.cancel()
    recognitionTask = nil
    
    timer?.invalidate()
    timer = nil
    minuteAndSeconds = 0
    recognizedText = ""
    
    voice = nil
    recordingData = Data()
  }
}

private extension RecordManager {
  // MARK: - 녹음 재개
  func resumeRecording() throws {
    do {
      try audioEngine.start()
      startTimer()
    } catch {
      throw RecordingError.audioError
    }
  }
  
  // MARK: - 새롭게 시작되는 레코딩 설정 + 시작과정
  func setupNewRecording() throws {
    minuteAndSeconds = 0
    
    do {
      // 타이머 시작
      startTimer()
      
      // 오디오 세션 설정
      let audioSession = AVAudioSession.sharedInstance()
      try audioSession.setCategory(.record, mode: .measurement)
      try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
      
      // 음성 인식 요청 설정
      recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
      
      guard let recognitionRequest = recognitionRequest else {
        throw RecordingError.audioError
      }
      
      recognitionRequest.shouldReportPartialResults = true
      
      // 오디오 엔진 설정
      let inputNode = audioEngine.inputNode
      let recordingFormat = inputNode.outputFormat(forBus: 0)
      
      inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { [weak self] buffer, _ in
        self?.recognitionRequest?.append(buffer)
        
        // AVAudioPCMBuffer을 Data 타입으로 변환
        if let channelData = buffer.floatChannelData?[0] {
          let frames = buffer.frameLength
          let data = Data(bytes: channelData, count: Int(frames) * MemoryLayout<Float>.size)
          self?.recordingData.append(data)
        }
      }
      
      audioEngine.prepare()
      
      try audioEngine.start()
      
      // 음성 인식 작업 시작
      recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { [weak self] result, error in
        guard let self = self else {
          return
        }
        
        if let result = result {
          self.recognizedText = result.bestTranscription.formattedString
        }
        
        if error != nil {
          self.audioEngine.stop()
          inputNode.removeTap(onBus: 0)
          self.recognitionRequest = nil
          self.recognitionTask = nil
        }
      }
    } catch {
      throw RecordingError.audioError
    }
  }
  
  func startTimer() {
    timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
      self?.minuteAndSeconds += 1
    }
  }
}
