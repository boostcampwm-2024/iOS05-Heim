//
//  DIContainer.swift
//  Core
//
//  Created by 정지용 on 11/6/24.
//

public typealias DependencyContainerClosure = (DIContainable) -> Any

public protocol DIContainable {
  func register<T>(type: T.Type, containerClosure: @escaping DependencyContainerClosure)
  func resolve<T>(type: T.Type) -> T?
}

public final class DIContainer: DIContainable {
  public static let shared: DIContainer = DIContainer()
  
  var services: [String: DependencyContainerClosure] = [:]
  
  private init() {}
  
  public func register<T>(type: T.Type, containerClosure: @escaping DependencyContainerClosure) {
    services["\(type)"] = containerClosure
  }
  
  public func resolve<T>(type: T.Type) -> T? {
    let service = services["\(type)"]?(self) as? T
    
    if service == nil {
      Logger.log(message: "\(#file) - \(#line): \(#function) - \(type) resolve error")
    }
    
    return service
  }
}
