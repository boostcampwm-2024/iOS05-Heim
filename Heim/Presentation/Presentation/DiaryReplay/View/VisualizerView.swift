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
    let amplitude = max(0, pow(10, power / 20))
    updateVisualizerPath(amplitude: CGFloat(amplitude))
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
    shapeLayer.fillColor = UIColor.systemBlue.cgColor
    layer.addSublayer(shapeLayer)
  }
}


//private func updateVisualizerPath(amplitude: CGFloat) {
//  layer.sublayers?.forEach { $0.removeFromSuperlayer() }
//
//  let path = UIBezierPath()
//  let centerY = bounds.midY
//  let totalPoints = 50
//  let maxHeight = bounds.height / 2
//  let widthStep = bounds.width / CGFloat(totalPoints - 1)
//
//  var previousY: CGFloat = centerY
//
//  for i in 0..<totalPoints {
//    let normalizedAmplitude = amplitude * CGFloat.random(in: 0.5...1.2)
//    let yOffset = normalizedAmplitude * maxHeight
//    let xPosition = CGFloat(i) * widthStep
//    let yPosition = centerY - yOffset
//
//    let controlY = (previousY + yPosition) / 2
//    if i == 0 {
//      path.move(to: CGPoint(x: xPosition, y: centerY))
//    } else {
//      path.addQuadCurve(
//        to: CGPoint(x: xPosition, y: yPosition),
//        controlPoint: CGPoint(x: xPosition - widthStep / 2, y: controlY)
//      )
//    }
//    previousY = yPosition
//  }
//
//  path.addLine(to: CGPoint(x: bounds.width, y: centerY))
//  path.addLine(to: CGPoint(x: 0, y: centerY))
//  path.close()
//
//  let shapeLayer = CAShapeLayer()
//  shapeLayer.path = path.cgPath
//  shapeLayer.fillColor = UIColor.systemBlue.withAlphaComponent(0.5).cgColor
//  shapeLayer.strokeColor = UIColor.systemBlue.cgColor
//  shapeLayer.lineWidth = 1
//  layer.addSublayer(shapeLayer)
//}
