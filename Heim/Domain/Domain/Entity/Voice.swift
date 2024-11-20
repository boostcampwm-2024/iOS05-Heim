//
//  Voice.swift
//  Domain
//
//  Created by 정지용 on 11/19/24.
//

import Foundation

public struct Voice: Codable {
  public let audioBuffer: Data
  public init(audioBuffer: Data) {
    self.audioBuffer = audioBuffer
  }
}
