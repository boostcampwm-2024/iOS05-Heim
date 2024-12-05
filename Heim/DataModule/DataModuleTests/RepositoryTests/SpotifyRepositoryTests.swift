//
//  SpotifyRepositoryTests.swift
//  DataModuleTests
//
//  Created by 정지용 on 12/5/24.
//

import XCTest
@testable import DataModule
@testable import Domain

final class SpotifyRepositoryTests: XCTestCase {
  var sut: SpotifyRepository!
  var mockNetworkProvider = MockNetworkProvider()

  override func setUp() {
    sut = DefaultSpotifyRepository(networkProvider: mockNetworkProvider)
  }
  
  override func tearDown() {
    sut = nil
    mockNetworkProvider = .init()
  }
  
  func test_fetch_recommend_tracks_through_fetchRecommendationTrack() async throws {
    // Given
    let input = Emotion.angry
    let mockDTO = SpotifyRecommendResponseDTO(tracks: [], seeds: [])
    
    // When
    mockNetworkProvider.returnValue.request = mockDTO
    let output = try await sut.fetchRecommendationTrack(input)
    
    // Then
    XCTAssertEqual(output, [])
  }
}
