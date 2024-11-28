//
//  DefaultSpotifyRepository.swift
//  DataModule
//
//  Created by 정지용 on 11/25/24.
//

import Domain

public struct DefaultSpotifyRepository: SpotifyRepository {
  private let networkProvider: NetworkProvider
  
  public init(networkProvider: NetworkProvider) {
    self.networkProvider = networkProvider
  }
  
  public func fetchRecommendationTrack(_ emotion: Emotion) async throws -> [MusicTrack] {
    return try await networkProvider.request(
      target: SpotifyAPI.recommendations(
        dto: SpotifyRecommendRequestDTOFactory.make(emotion)
      ),
      type: SpotifyRecommendResponseDTO.self
    ).tracks.map { SpotifyTrack.toEntity($0) }
  }
}
