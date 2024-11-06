//
//  ViewModel.swift
//  Presentation
//
//  Created by 정지용 on 11/6/24.
//

protocol ViewModel {
  associatedtype Action
  associatedtype State

  var state: State { get }

  func action(
    _ action: Action
  )
}
