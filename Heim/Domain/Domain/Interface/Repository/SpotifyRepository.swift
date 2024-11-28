//
//  SpotifyRepository.swift
//  Domain
//
//  Created by 정지용 on 11/25/24.
//

public protocol SpotifyRepository {
  func fetchRecommendationTrack(_ dto: Emotion) async throws -> [MusicTrack]
}
