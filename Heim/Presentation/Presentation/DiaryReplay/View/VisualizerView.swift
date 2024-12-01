//
//  VisualizerView.swift
//  Presentation
//
//  Created by 정지용 on 11/28/24.
//

import AVFoundation
import UIKit

final class VisualizerView: UIView {
  private var displayLink: CADisplayLink?
  private weak var viewModel: DiaryReplayViewModel?
  private var defaultAmplitude: CGFloat = 1
  private var maxDecibel: Float = -160.0
  private let totalBars = 30
  private let amplitudeScalingFactor: CGFloat = 1.5
  
  func startVisualizer(for viewModel: DiaryReplayViewModel?) {
    self.viewModel = viewModel
    displayLink?.invalidate()
    displayLink = CADisplayLink(target: self, selector: #selector(updateVisualizer))
    displayLink?.add(to: .main, forMode: .common)
    
    guard let replayManager = viewModel?.diaryReplayManager else { return }
    replayManager.calculateMaxDecibel { [weak self] maxDecibel in
      DispatchQueue.main.async {
        self?.maxDecibel = max(maxDecibel ?? -160.0, -60)
      }
    }
  }
  
  func stopVisualizer() {
    displayLink?.invalidate()
    displayLink = nil
  }
  
  @objc
  private func updateVisualizer() {
    guard let manager = viewModel?.diaryReplayManager else { return }
    
    manager.audioPlayer.updateMeters()
    
    let power = manager.audioPlayer.averagePower(forChannel: 0)
    let amplitude = calculateAmplitude(for: power)
    updateVisualizerPath(amplitude: amplitude)
  }
  
  private func calculateAmplitude(for power: Float) -> CGFloat {
    let maxAmplitude = CGFloat(pow(10, maxDecibel / 20))
    let currentAmplitude = CGFloat(pow(10, power / 20))
    let normalizedAmplitude = currentAmplitude / maxAmplitude
    return max(normalizedAmplitude * bounds.height, defaultAmplitude)
  }
  
  private func updateVisualizerPath(amplitude: CGFloat) {
    layer.sublayers?.forEach { $0.removeFromSuperlayer() }
    
    let path = UIBezierPath()
    let barWidth = bounds.width / CGFloat(totalBars)
    let maxHeight = bounds.height
    let centerY = bounds.midY
    
    for sequence in 0..<totalBars {
      let randomizedAmplitude = amplitude * CGFloat.random(in: 0.5...amplitudeScalingFactor)
      let barHeight = min(randomizedAmplitude, maxHeight)
      let xPosition = CGFloat(sequence) * barWidth
      let barRect = CGRect(
        x: xPosition,
        y: centerY - barHeight / 2,
        width: barWidth - 2,
        height: barHeight
      )
      path.append(UIBezierPath(rect: barRect))
    }
    
    let shapeLayer = CAShapeLayer()
    shapeLayer.path = path.cgPath
    shapeLayer.fillColor = UIColor.secondary.cgColor
    layer.addSublayer(shapeLayer)
  }
}
