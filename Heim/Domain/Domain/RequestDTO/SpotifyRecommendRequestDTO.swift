//
//  SpotifyRecommendRequestDTO.swift
//  Domain
//
//  Created by 정지용 on 11/25/24.
//

import Foundation

/// Spotify - Recommendation API
///
/// seed* 파라미터들은 필수입니다. 이 3개의 파라미터를 조합하여 최대 5개까지 작성할 수 있습니다.
/// 앞선 조건에 따라 최소 1개 이상의 파라미터를 채워야 합니다. 이 3개의 파라미터를 조합한 결과가 있어야 하므로 Required로 분류합니다.
///
/// 만약 2개 이상의 값을 넣는 경우 쉼표로 구분하여 하나의 String으로 만듭니다.
/// 3개 모두 채워지지 않아도 됩니다. 단 최소 한개의 파라미터는 채워져야 하며, 사용하지 않는 파라미터는 nil로 비웁니다.
public struct SpotifyRecommendRequestDTO: DictionaryRepresentable {
  // Required Parameters
  private let seedArtists: String?
  private let seedGenres: String?
  private let seedTracks: String?
  
  // Optional Parameters - Min
  private let minEnergy: Double?
  private let minDanceability: Double?
  private let minTempo: Double?
  private let minValence: Double?
  
  // Optional Parameters - Max
  private let maxEnergy: Double?
  private let maxTempo: Double?
  private let maxValence: Double?
  
  // Optional Parameters - Target
  private let targetAcousticness: Double?
  private let targetDanceability: Double?
  private let targetEnergy: Double?
  private let targetLiveness: Double?
  private let targetLoudness: Double?
  private let targetSpeechiness: Double?
  private let targetTempo: Double?
  private let targetValence: Double?
  
  public init(
    seedArtists: String? = nil,
    seedGenres: String? = nil,
    seedTracks: String? = nil,
    minEnergy: Double? = nil,
    minDanceability: Double? = nil,
    minTempo: Double? = nil,
    minValence: Double? = nil,
    maxEnergy: Double? = nil,
    maxTempo: Double? = nil,
    maxValence: Double? = nil,
    targetAcousticness: Double? = nil,
    targetDanceability: Double? = nil,
    targetEnergy: Double? = nil,
    targetLiveness: Double? = nil,
    targetLoudness: Double? = nil,
    targetSpeechiness: Double? = nil,
    targetTempo: Double? = nil,
    targetValence: Double? = nil
  ) {
    self.seedArtists = seedArtists
    self.seedGenres = seedGenres
    self.seedTracks = seedTracks
    self.minEnergy = minEnergy
    self.minDanceability = minDanceability
    self.minTempo = minTempo
    self.minValence = minValence
    self.maxEnergy = maxEnergy
    self.maxTempo = maxTempo
    self.maxValence = maxValence
    self.targetAcousticness = targetAcousticness
    self.targetDanceability = targetDanceability
    self.targetEnergy = targetEnergy
    self.targetLiveness = targetLiveness
    self.targetLoudness = targetLoudness
    self.targetSpeechiness = targetSpeechiness
    self.targetTempo = targetTempo
    self.targetValence = targetValence
  }
  
  public var dictionary: [String: Any] {
    return self.toSnakeCaseDictionary()
  }
}
