//
//  UITableView+.swift
//  Presentation
//
//  Created by 한상진 on 11/7/24.
//

import UIKit

extension UITableView {
  func registerCellClass(cellType: UITableViewCell.Type) {
    let identifier: String = "\(cellType)"
    register(cellType, forCellReuseIdentifier: identifier)
  }
  
  func registerCellClasses(_ cellTypes: [UITableViewCell.Type]) {
    cellTypes.forEach {
      let identifier: String = "\($0)"
      register($0, forCellReuseIdentifier: identifier)
    }
  }
  
  func registerHeaderFooterClass(viewType: UITableViewHeaderFooterView.Type) {
    let identifier: String = "\(viewType)"
    register(viewType, forHeaderFooterViewReuseIdentifier: identifier)
  }
  
  func dequeueReusableCell<T: UITableViewCell>(cellType: T.Type = T.self, indexPath: IndexPath) -> T? {
    guard let cell = dequeueReusableCell(withIdentifier: "\(cellType)", for: indexPath) as? T else { return nil } 
    return cell
  }
  
  func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>(viewType: T.Type = T.self) -> T? {
    guard let cell = dequeueReusableHeaderFooterView(withIdentifier: "\(viewType)") as? T else { return nil }
    return cell
  }
}
