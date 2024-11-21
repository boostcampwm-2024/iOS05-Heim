//
//  DefaultNetworkProvider.swift
//  NetworkModule
//
//  Created by 정지용 on 11/12/24.
//

import DataModule
import Foundation

// MARK: - NetworkRequestable
public protocol NetworkRequestable {
  func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

// MARK: - URLSession Extension
extension URLSession: NetworkRequestable {}

// MARK: - DefaultNetworkProvider
public struct DefaultNetworkProvider: NetworkProvider {
  private let requestor: NetworkRequestable
  
  public init(requestor: NetworkRequestable) {
    self.requestor = requestor
  }
  
  @discardableResult
  public func request<T: Decodable>(target: RequestTarget, type: T.Type) async throws -> T {
    // TODO: NSError -> 다른 Error Type으로 변경
    let request = try target.makeURLRequest()
    let (data, response) = try await requestor.data(for: request)
    
    guard let responseDTO = try? JSONDecoder().decode(T.self, from: data) else {
      throw NSError()
    }
    
    return responseDTO
  }
  
  public func makeURL(target: any RequestTarget) throws -> URL? {
    return try target.makeURLRequest().url
  }
}
