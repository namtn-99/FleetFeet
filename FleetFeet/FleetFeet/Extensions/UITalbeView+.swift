//
//  UITalbeView+.swift
//  FleetFeet
//
//  Created by trinh.ngoc.nam on 5/15/24.
//

import UIKit

public extension UITableView {
    /**
     Register a NIB-Based `UITableViewCell` subclass (conforming to `Reusable` & `NibLoadable`)
     
     - parameter cellType: the `UITableViewCell` (`Reusable` & `NibLoadable`-conforming) subclass to register
     
     - seealso: `register(_:,forCellReuseIdentifier:)`
     */
    final func register<T: UITableViewCell>(cellType: T.Type)
    where T: Reusable & NibLoadable {
        self.register(cellType.nib, forCellReuseIdentifier: cellType.reuseIdentifier)
    }
    
    final func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath, cellType: T.Type = T.self) -> T
      where T: Reusable {
        guard let cell = self.dequeueReusableCell(withIdentifier: cellType.reuseIdentifier, for: indexPath) as? T else {
          fatalError(
            "Failed to dequeue a cell with identifier \(cellType.reuseIdentifier) matching type \(cellType.self). "
              + "Check that the reuseIdentifier is set properly in your XIB/Storyboard "
              + "and that you registered the cell beforehand"
          )
        }
        return cell
    }
}
