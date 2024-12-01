//
//  VisualizerView.swift
//  Presentation
//
//  Created by 정지용 on 11/28/24.
//

import UIKit

final class VisualizerView: UIView {
  private var displayLink: CADisplayLink?
  private weak var viewModel: DiaryReplayViewModel?
  private var defaultAmplitude: CGFloat = 0.01

  func startVisualizer(for viewModel: DiaryReplayViewModel?) {
    self.viewModel = viewModel
    displayLink?.invalidate()
    displayLink = CADisplayLink(target: self, selector: #selector(updateVisualizer))
    displayLink?.add(to: .main, forMode: .common)
  }

  func stopVisualizer() {
    displayLink?.invalidate()
    displayLink = nil
  }

  @objc private func updateVisualizer() {
    guard let manager = viewModel?.diaryReplayManager else { return }
    manager.audioPlayer.updateMeters()

    let power = manager.audioPlayer.averagePower(forChannel: 0)
    let amplitude = pow(10, power / 20)
    updateVisualizerPath(amplitude: CGFloat(max(CGFloat(amplitude) * 15, defaultAmplitude)))
  }

  private func updateVisualizerPath(amplitude: CGFloat) {
    layer.sublayers?.forEach { $0.removeFromSuperlayer() }
    
    let path = UIBezierPath()
    let centerY = bounds.midY
    let totalBars = 20
    let barWidth: CGFloat = bounds.width / CGFloat(totalBars)
    let maxHeight = bounds.height / 2
    
    for i in 0..<totalBars {
      let normalizedAmplitude = amplitude * CGFloat.random(in: 0.5...1.5)
      let barHeight = normalizedAmplitude * maxHeight
      let xPosition = CGFloat(i) * barWidth
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
