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
  private var audioRecorder: AVAudioRecorder?
  private var recordingURL: URL
  private var timer: Timer?
  
  // MARK: - 음성 데이터
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
    
    // 임시 녹음 파일 URL 생성
    let documentsPath = FileManager.default.temporaryDirectory
    self.recordingURL = documentsPath.appendingPathComponent("temporaryRecording.wav")
  }
  
  // MARK: - 녹음과정 준비
  func setupSpeech() async throws {
    let speechStatus = await withCheckedContinuation { continuation in
      SFSpeechRecognizer.requestAuthorization { status in
        continuation.resume(returning: status)
      }
    }
    
    // 마이크 권한 확인
    let micStatus = await AVCaptureDevice.requestAccess(for: .audio)
    let micAuthStatus = AVCaptureDevice.authorizationStatus(for: .audio)
    
    switch (speechStatus, micStatus, micAuthStatus) {
    case (.authorized, true, _):
      return
    case (.notDetermined, _, _), (_, _, .notDetermined):
      return
    default:
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
    audioRecorder?.stop()
    
    // 녹음된 파일을 Data로 변환
    guard let audioData = try? Data(contentsOf: recordingURL) else {
      return
    }
    
    voice = Voice(audioBuffer: audioData)
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
    
    // 임시 파일 삭제
    try? FileManager.default.removeItem(at: recordingURL)
  }
}

private extension RecordManager {
  // MARK: - 녹음 재개
  func resumeRecording() throws {
    do {
      try audioEngine.start()
      audioRecorder?.record()
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
      try audioSession.setCategory(.playAndRecord,
                                 mode: .default,
                                 options: [.defaultToSpeaker, .allowBluetooth])
      try audioSession.setActive(true, options: .notifyOthersOnDeactivation)

      // PCM 설정
      let settings: [String: Any] = [
          AVFormatIDKey: Int(kAudioFormatLinearPCM),
          AVSampleRateKey: 44100.0,
          AVNumberOfChannelsKey: 2,  // 스테레오로 변경
          AVLinearPCMBitDepthKey: 16,
          AVLinearPCMIsFloatKey: false,
          AVLinearPCMIsBigEndianKey: false,
          AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue
      ]
      
      // 기존 파일이 있다면 제거
      if FileManager.default.fileExists(atPath: recordingURL.path) {
        try FileManager.default.removeItem(at: recordingURL)
      }
      
      audioRecorder = try AVAudioRecorder(url: recordingURL, settings: settings)
      
      guard let audioRecorder = audioRecorder else {
        throw RecordingError.audioError
      }
      
      audioRecorder.isMeteringEnabled = true
      guard audioRecorder.prepareToRecord() else {
        throw RecordingError.audioError
      }
      
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
      }
      
      audioEngine.prepare()
      try audioEngine.start()
      audioRecorder.record()
      
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
