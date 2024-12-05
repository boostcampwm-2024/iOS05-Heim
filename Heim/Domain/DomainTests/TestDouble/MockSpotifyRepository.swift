//
//  MockSpotifyRepository.swift
//  DomainTests
//
//  Created by 정지용 on 12/5/24.
//

@testable import Domain

final class MockSpotifyRepository: SpotifyRepository {
  struct CallCount {
    var fetchRecommendationTrack = 0
  }
  
  struct Return {
    var fetchRecommendationTrack: [MusicTrack]!
  }
  
  var callCount = CallCount()
  var returnValue = Return()
  
  func fetchRecommendationTrack(_ dto: Emotion) async throws -> [MusicTrack] {
    callCount.fetchRecommendationTrack += 1
    return returnValue.fetchRecommendationTrack
  }
}
