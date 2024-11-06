//
//  Coordinatable.swift
//  Presentation
//
//  Created by 정지용 on 11/6/24.
//

import Foundation

protocol Coordinatable: AnyObject {
  associatedtype AssociatedCoordinatorType: Coordinator
  
  var coordinator: AssociatedCoordinatorType? { get }
}
