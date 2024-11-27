//
//  DefaultSpotifyRepository.swift
//  DataModule
//
//  Created by 정지용 on 11/25/24.
//

import Domain

public struct DefaultSpotifyRepository: SpotifyRepository {
  private let networkProvider: NetworkProvider
  private let tokenStorage: TokenStorage
  
  public init(
    networkProvider: NetworkProvider,
    tokenStorage: TokenStorage
  ) {
    self.networkProvider = networkProvider
    self.tokenStorage = tokenStorage
  }
  
  public func fetchRecommendationTrack(_ emotion: Emotion) async throws -> [Track] {
    guard let accessToken = tokenStorage.load(attrAccount: SpotifyEnvironment.accessTokenAttributeKey) else {
      throw StorageError.readError
    }
    return try await networkProvider.request(
      target: SpotifyAPI.recommendations(
        dto: SpotifyRecommendRequestDTOFactory.shared.make(emotion),
        accessToken: accessToken
      ),
      type: SpotifyRecommendResponseDTO.self
    ).tracks.map { SpotifyTrack.toEntity($0) }
  }
}
