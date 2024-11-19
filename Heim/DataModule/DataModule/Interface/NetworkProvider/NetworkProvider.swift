//
//  NetworkProvider.swift
//  DataModule
//
//  Created by 정지용 on 11/6/24.
//

public protocol NetworkProvider {
  
  @discardableResult
  func request<T: Decodable>(target: RequestTarget, type: T.Type) async throws -> T
}
