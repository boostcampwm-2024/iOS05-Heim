//
//  RecordManager.swift
//  Presentation
//
//  Created by 박성근 on 11/18/24.
//

import UIKit
import Speech
import AVFoundation

final class RecordManager {
  // MARK: - 음성 인식을 위한 Properties
  private let speechRecognizer: SFSpeechRecognizer
  private let audioEngine: AVAudioEngine
  
  private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
  private var recognitionTask: SFSpeechRecognitionTask?
  
  // MARK: - 음성 녹음을 위한 Properties
  private var audioRecorder: AVAudioRecorder?
  private var timer: Timer?
  
  // MARK: - 인식된 텍스트, 경과한 시간
  private(set) var recognizedText: String
  private(set) var minuteAndSeconds: Int
  
  init(locale: Locale = Locale(identifier: "ko-KR")) {
    self.speechRecognizer = SFSpeechRecognizer(locale: locale)!
    self.audioEngine = AVAudioEngine()
    self.recognizedText = ""
    self.minuteAndSeconds = 0
  }
  
  // MARK: - 녹음과정 준비
  func setupSpeech() async throws {
    let authStatus = await withCheckedContinuation { continuation in
      SFSpeechRecognizer.requestAuthorization { status in
        continuation.resume(returning: status)
      }
    }
    
    // TODO: 에러 핸들링(.authorized 제외) -> Merge 이후 수정 예정
    switch authStatus {
    case .authorized:
      return
    case .denied, .restricted, .notDetermined:
      return
    @unknown default:
      return
    }
  }
  
  // TODO: 현재 audioRecorder가 Stop되면 바로 설정한 URL에 m4a 파일이 저장됨. -> 데이터로 변환 필요
  func setupAudioRecorder() throws {
    let settings: [String: Any] = [
      AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
      AVSampleRateKey: 12000,
      AVNumberOfChannelsKey: 1,
      AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
    ]
    
    audioRecorder = try AVAudioRecorder(url: getAudioFileURL(), settings: settings)
    audioRecorder?.prepareToRecord()
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
    
    audioRecorder?.stop()
  }
}

private extension RecordManager {
  // MARK: - 녹음 재개
  func resumeRecording() throws {
    try audioEngine.start()
    startTimer()
  }
  
  // MARK: - 새롭게 시작되는 레코딩 설정 + 시작과정
  func setupNewRecording() throws {
    minuteAndSeconds = 0
    
    // 타이머 시작
    startTimer()
    
    // 오디오 세션 설정
    let audioSession = AVAudioSession.sharedInstance()
    try audioSession.setCategory(.record, mode: .measurement)
    try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
    
    // 오디오 레코더 설정
    try setupAudioRecorder()
    audioRecorder?.record()
    
    // 음성 인식 요청 설정
    recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
    
    guard let recognitionRequest = recognitionRequest else {
      // TODO: 에러처리
      return
    }
    
    recognitionRequest.shouldReportPartialResults = true
    
    // 오디오 엔진 설정
    let inputNode = audioEngine.inputNode
    let recordingFormat = inputNode.outputFormat(forBus: 0)
    
    inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
      self.recognitionRequest?.append(buffer)
    }
    
    audioEngine.prepare()
    
    try audioEngine.start()
    
    // 음성 인식 작업 시작
    recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { [weak self] result, error in
      guard let self = self else {
        // TODO: 에러로 변경
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
  }
  
  func getAudioFileURL() -> URL {
    let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    return documentsPath.appendingPathComponent("recoding.m4a")
  }
  
  func startTimer() {
    timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
      self?.minuteAndSeconds += 1
    }
  }
}
