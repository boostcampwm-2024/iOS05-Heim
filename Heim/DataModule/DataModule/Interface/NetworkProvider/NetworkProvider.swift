//
//  NetworkProvider.swift
//  DataModule
//
//  Created by 정지용 on 11/6/24.
//

import Foundation

public protocol NetworkProvider {
  
  @discardableResult
  func request<T: Decodable>(target: RequestTarget, type: T.Type) async throws -> T
  
  func makeURL(target: RequestTarget) throws -> URL?
}
