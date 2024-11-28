//
//  UICollectionView+.swift
//  Presentation
//
//  Created by 한상진 on 11/26/24.
//

import UIKit

extension UICollectionView {
  func registerCellClass(cellType: UICollectionViewCell.Type) {
    let identifer: String = "\(cellType)"
    register(cellType, forCellWithReuseIdentifier: identifer)
  }
  
  func registerCellClasses(_ cellTypes: [UICollectionViewCell.Type]) {
    cellTypes.forEach {
      let identifier: String = "\($0)"
      register($0, forCellWithReuseIdentifier: identifier)
    }
  }
  
  func dequeueReusableCell<T: UICollectionViewCell>(indexPath: IndexPath, cellType: T.Type = T.self) -> T? {
    guard let cell = dequeueReusableCell(withReuseIdentifier: "\(cellType)", for: indexPath) as? T else { return nil } 
    return cell
  }
}
