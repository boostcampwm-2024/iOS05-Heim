//
//  MockMusicRepository.swift
//  DomainTests
//
//  Created by 정지용 on 12/5/24.
//

@testable import Domain

final class MockMusicRepository: MusicRepository {
  struct CallCount {
    var hasMusicAccess = 0
    var isAppleMusicSubscribed = 0
    var playMusicWithMusicKit = 0
    var playPreviewWithAVPlayer = 0
    var pause = 0
  }
  
  struct Return {
    var hasMusicAccess: Bool!
    var isAppleMusicSubscribed: Bool!
  }
  
  var callCount = CallCount()
  var returnValue = Return()
  
  func hasMusicAccess() async throws -> Bool {
    callCount.hasMusicAccess += 1
    return returnValue.hasMusicAccess
  }
  
  func isAppleMusicSubscribed() async throws -> Bool {
    callCount.isAppleMusicSubscribed += 1
    return returnValue.isAppleMusicSubscribed
  }
  
  func playMusicWithMusicKit(_ isrc: String) async throws {
    callCount.playMusicWithMusicKit += 1
  }
  
  func playPreviewWithAVPlayer(_ isrc: String) async throws {
    callCount.playPreviewWithAVPlayer += 1
  }
  
  func pause() throws {
    callCount.pause += 1
  }
}
