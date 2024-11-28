//
//  SpotifyRecommendRequestDTOFactory.swift
//  Domain
//
//  Created by 정지용 on 11/25/24.
//

import Domain
import Foundation

public enum SpotifyRecommendRequestDTOFactory {
  public static func make(_ emotion: Emotion) throws -> SpotifyRecommendRequestDTO {
    switch emotion {
    case .angry:
      return SpotifyRecommendRequestDTO(
        seedGenres: "metal",
        minEnergy: 0.8,
        maxValence: 0.4,
        targetAcousticness: 0.1,
        targetLoudness: -5,
        targetSpeechiness: 0.3,
        targetTempo: 160
      )
    case .disgust:
      return SpotifyRecommendRequestDTO(
        seedGenres: "blues",
        minEnergy: 0.2,
        maxEnergy: 0.6,
        targetLoudness: -18,
        targetSpeechiness: 0.4,
        targetTempo: 80,
        targetValence: 0.3
      )
    case .fear:
      return SpotifyRecommendRequestDTO(
        seedGenres: "soundtrack",
        minEnergy: 0.1,
        maxValence: 0.3,
        targetAcousticness: 0.5,
        targetLoudness: -25,
        targetSpeechiness: 0.6
      )
    case .happiness:
      return SpotifyRecommendRequestDTO(
        seedGenres: "pop",
        minEnergy: 0.7,
        minDanceability: 0.7,
        maxEnergy: 1.0,
        targetLiveness: 0.2,
        targetTempo: 120,
        targetValence: 0.9
      )
    case .neutral:
      return SpotifyRecommendRequestDTO(
        seedGenres: "chill",
        targetAcousticness: 0.4,
        targetDanceability: 0.5,
        targetEnergy: 0.5,
        targetTempo: 100,
        targetValence: 0.5
      )
    case .sadness:
      return SpotifyRecommendRequestDTO(
        seedGenres: "acoustic",
        minEnergy: 0.1,
        minValence: 0.1,
        maxEnergy: 0.4,
        maxValence: 0.3,
        targetAcousticness: 0.8,
        targetLoudness: -20,
        targetTempo: 65
      )
    case .surprise:
      return SpotifyRecommendRequestDTO(
        seedGenres: "edm",
        minEnergy: 0.5,
        minTempo: 120,
        maxEnergy: 0.9,
        maxTempo: 150,
        targetLiveness: 0.8,
        targetValence: 0.6
      )
    case .none:
      throw EmotionError.noneEmotionException
    @unknown default:
      throw EmotionError.noneEmotionException
    }
  }
}
