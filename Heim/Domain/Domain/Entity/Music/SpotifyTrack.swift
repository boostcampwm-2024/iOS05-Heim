//
//  SpotifyTrack.swift
//  Domain
//
//  Created by 정지용 on 11/25/24.
//

import Foundation

public struct SpotifyTrack: Decodable {
  public let album: Album
  public let artists: [Artist]
  public let id: String
  public let name: String
  public let durationMS: Int
  public let explicit: Bool
  public let popularity: Int
  public let previewURL: String?
  public let uri: String
  public let externalIDs: ExternalIDs
  
  enum CodingKeys: String, CodingKey {
    case album, artists, id, name
    case durationMS = "duration_ms"
    case explicit, popularity
    case previewURL = "preview_url"
    case uri
    case externalIDs = "external_ids"
  }
  
  public static func toEntity(_ spotifyTrack: Self) -> MusicTrack {
    return MusicTrack(
      thumbnail: spotifyTrack.album.albumArtURL,
      title: spotifyTrack.name,
      artist: spotifyTrack.artists.map { $0.name }.joined(separator: ", "),
      isrc: spotifyTrack.externalIDs.isrc
    )
  }
}

public struct Album: Decodable {
  public let id: String
  public let name: String
  public let releaseDate: String
  public let images: [AlbumImage]
  
  var albumArtURL: URL? {
    return images.first?.wrappedURL
  }
  
  enum CodingKeys: String, CodingKey {
    case id, name
    case releaseDate = "release_date"
    case images
  }
}

public struct AlbumImage: Decodable {
  public let url: String
  public let height: Int
  public let width: Int
  
  var wrappedURL: URL? {
    return URL(string: url)
  }
}

public struct Artist: Decodable {
  public let id: String
  public let name: String
}

public struct ExternalIDs: Decodable {
  public let isrc: String
}
