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
  let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "ko-KR"))
  var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
  var recognitionTask: SFSpeechRecognitionTask?
  private let audioEngine = AVAudioEngine()
  public var recognizedText: String = ""
  
  // MARK: - 음성 녹음을 위한 Properties
  var audioRecorder: AVAudioRecorder?
  
  // MARK: - 타이머
  private var timer: Timer?
  public var minuteAndSeconds: Int
  
  init(
    recognitionRequest: SFSpeechAudioBufferRecognitionRequest? = nil,
    recognitionTask: SFSpeechRecognitionTask? = nil,
    recognizedText: String,
    audioRecorder: AVAudioRecorder? = nil,
    timer: Timer? = nil,
    minuteAndSeconds: Int
  ) {
    self.recognitionRequest = recognitionRequest
    self.recognitionTask = recognitionTask
    self.recognizedText = recognizedText
    self.audioRecorder = audioRecorder
    self.timer = timer
    self.minuteAndSeconds = minuteAndSeconds
  }
  
  // TODO: 언제 setupSpeech를 부를지? 값은 어떻게 Usecase에서 판단할지
  public func setupSpeech() async {
    let authStatus = await withCheckedContinuation { continuation in
      SFSpeechRecognizer.requestAuthorization { status in
        continuation.resume(returning: status)
      }
    }
    
    // TODO: 에러 핸들링
    switch authStatus {
    case .authorized:
      return
    case .denied, .restricted, .notDetermined:
      return
    @unknown default:
      return
    }
  }
  
  // TODO: 현재 audioRecorder가 Stop되면 바로 설정한 URL에 m4a 파일이 저장됨.
  // 이를 어떻게 파일만 들고 나중에 저장할 수 있을 지 추후 수정해야함.
  public func setupAudioRecorder() {
    let audioFileName = getAudioFileURL()
    
    let settings: [String: Any] = [
      AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
      AVSampleRateKey: 12000,
      AVNumberOfChannelsKey: 1,
      AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
    ]
    
    do {
      audioRecorder = try AVAudioRecorder(url: audioFileName, settings: settings)
      audioRecorder?.prepareToRecord()
    } catch {
      print("Audio Recorder Settings error")
    }
  }
  
  public func startRecording() {
    if recognitionRequest == nil {
      // MARK: - 새로운 녹음 시작
      setupNewRecording()
    } else {
      // MARK: - 일시중지 된 상태에서 다시 재개
      do {
        try audioEngine.start()
        
        // 타이머 재시작
        timer = Timer.scheduledTimer(
          withTimeInterval: 1.0,
          repeats: true
        ) { [weak self] _ in
          guard let self = self else { return }
          self.minuteAndSeconds += 1
        }
      } catch {
        // TODO: 에러 처리
      }
    }
  }
  
  // MARK: - 일시중지
  public func stopRecording() {
    audioEngine.pause()
    
    timer?.invalidate()
    timer = nil
  }
  
  public func resetAll() {
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
  // MARK: - 새롭게 시작되는 레코딩 설정 + 시작과정
  func setupNewRecording() {
    minuteAndSeconds = 0
    
    // 타이머 시작
    timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
      guard let self = self else { return }
      self.minuteAndSeconds += 1
    }
    
    // 오디오 세션 설정
    let audioSession = AVAudioSession.sharedInstance()
    do {
      try audioSession.setCategory(.record, mode: .measurement)
      try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
    } catch {
      // TODO: 에러 처리
      return
    }
    
    // 오디오 레코더 설정
    setupAudioRecorder()
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
    
    do {
      try audioEngine.start()
    } catch {
      // TODO: 에러 처리
      return
    }
    
    // 음성 인식 작업 시작
    recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { [weak self] result, error in
      guard let self = self else { return }
      
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
}
