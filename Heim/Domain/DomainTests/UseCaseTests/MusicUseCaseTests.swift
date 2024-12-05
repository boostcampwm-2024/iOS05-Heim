//
//  MusicUseCaseTests.swift
//  DomainTests
//
//  Created by 정지용 on 12/5/24.
//

import XCTest
@testable import Domain

final class MusicUseCaseTests: XCTestCase {
  var sut: MusicUseCase!
  var mockSpotifyRepository = MockSpotifyRepository()
  var mockMusicRepository = MockMusicRepository()
  
  override func setUp() {
    sut = DefaultMusicUseCase(
      spotifyRepository: mockSpotifyRepository,
      musicRepository: mockMusicRepository
    )
  }
  
  override func tearDown() {
    sut = nil
    mockSpotifyRepository = .init()
    mockMusicRepository = .init()
  }
  
  func test_fetch_recommendation_tracks_through_fetchRecommendationTrack() async throws {
    // Given
    let input = Emotion.angry
    let mockMusicTrack = MusicTrack(
      thumbnail: URL(string: "test"),
      title: "test",
      artist: "test",
      isrc: "test12345678"
    )
    
    // When
    mockSpotifyRepository.returnValue.fetchRecommendationTrack = [mockMusicTrack]
    let output = try await sut.fetchRecommendTracks(input)
    
    // Then
    XCTAssertEqual(output, [mockMusicTrack])
  }
  
  func test_play_successfully_without_error_when_subscribed() async throws {
    // Given
    let input = "test"
    
    // When
    mockMusicRepository.returnValue.hasMusicAccess = true
    mockMusicRepository.returnValue.isAppleMusicSubscribed = true
    try await sut.play(to: input)
    
    // Then
    XCTAssert(true)
  }
  
  func test_play_successfully_without_error_when_not_subscribed() async throws {
    // Given
    let input = "test"
    
    // When
    mockMusicRepository.returnValue.hasMusicAccess = true
    mockMusicRepository.returnValue.isAppleMusicSubscribed = false
    try await sut.play(to: input)
    
    // Then
    XCTAssert(true)
  }
  
  func test_play_failed_when_no_music_access() async throws {
    let input = "test"
    
    mockMusicRepository.returnValue.hasMusicAccess = false
    do {
      try await sut.play(to: input)
      XCTFail("위 호출은 반드시 실패해야 함")
    } catch {
      XCTAssert(true)
    }
  }
  
  func test_pause_successfully_without_error() throws {
    // Given
    
    // When
    try sut.pause()
    
    // Then
    XCTAssert(true)
  }
}
