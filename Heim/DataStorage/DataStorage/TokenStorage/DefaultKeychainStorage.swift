//
//  DefaultKeychainStorage.swift
//  DataStorage
//
//  Created by 정지용 on 11/21/24.
//

import DataModule
import Domain
import Foundation
import Security

public struct DefaultKeychainStorage: KeychainStorage {
  public init() {}
  
  public func save<T: Encodable>(_ data: T, attrAccount: String) throws {
    let jsonData: Data
    if let stringData = data as? String {
      jsonData = Data(stringData.utf8)
    } else {
      jsonData = try JSONEncoder().encode(data)
    }
    
    let query: NSDictionary = [
      kSecClass: kSecClassGenericPassword,
      kSecAttrAccount: attrAccount,
      kSecValueData: jsonData
    ]
    
    SecItemDelete(query as CFDictionary)
    let status = SecItemAdd(query as CFDictionary, nil)
    if status != errSecSuccess {
      throw StorageError.writeError
    }
  }
  
  public func load<T: Decodable>(attrAccount: String) throws -> T {
    let query: NSDictionary = [
      kSecClass: kSecClassGenericPassword,
      kSecAttrAccount: attrAccount,
      kSecReturnData: kCFBooleanTrue as Any,
      kSecMatchLimit: kSecMatchLimitOne
    ]
    
    var dataTypeRef: AnyObject?
    let status = SecItemCopyMatching(query, &dataTypeRef)
    guard status == errSecSuccess,
          let tokenData = dataTypeRef as? Data else { throw StorageError.readError }
    
    let decoder = JSONDecoder()
    do {
      let decodedObject = try decoder.decode(T.self, from: tokenData)
      return decodedObject
    } catch {
      throw JSONError.decodingError
    }
  }
  
  public func delete(attrAccount: String) throws {
    let query: NSDictionary = [
      kSecClass: kSecClassGenericPassword,
      kSecAttrAccount: attrAccount
    ]
    
    if SecItemDelete(query as CFDictionary) != errSecSuccess {
      throw StorageError.deleteError
    }
  }
}
