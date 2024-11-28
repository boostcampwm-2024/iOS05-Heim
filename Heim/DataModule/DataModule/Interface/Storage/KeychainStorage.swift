//
//  KeychainStorage.swift
//  DataModule
//
//  Created by 정지용 on 11/21/24.
//

public protocol KeychainStorage {
  func save<T: Encodable>(_ data: T, attrAccount: String) throws
  func load<T: Decodable>(attrAccount: String) throws -> T
  func delete(attrAccount: String) throws
}
