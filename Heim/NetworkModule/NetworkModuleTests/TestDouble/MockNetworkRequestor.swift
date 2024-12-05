//
//  MockNetworkRequestor.swift
//  NetworkModule
//
//  Created by 김미래 on 12/5/24.
//

@testable import Domain
@testable import NetworkModule
import Foundation

final class MockNetworkRequestor: NetworkRequestable {
  // MARK: - Properties
  var response: URLResponse?
  var data: Data?
  var error: Error?

  // MARK: - Methods
  func data(for request: URLRequest) async throws -> (Data, URLResponse) {
    if let error = error {
      throw error
    }
    guard let data = data, let response = response else {
      throw NetworkError.serverError
    }

    return (data, response)
  }

  func setURLResponse(_ urlResponse: URLResponse?) {
    error = nil
    self.response = urlResponse
  }

  func setResponseData(_ responseData: Data?) {
    error = nil
    self.data = responseData
  }

  func setError(_ errorReponse: Error?) {
    response = nil
    data = nil
    self.error = errorReponse
  }
}
