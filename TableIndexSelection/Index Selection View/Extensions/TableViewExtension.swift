//
//  TableViewExtension.swift
//  TableIndexSelection
//
//  Created by Insight Workshop on 12/2/19.
//  Copyright © 2019 Skyway Innovation. All rights reserved.
//

import UIKit

extension UITableView {
    
    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T where T: ReusableView {
        guard let cell = dequeueReusableCell(withIdentifier: T.defaultReuseIdentififer, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.defaultReuseIdentififer)")
        }
        return cell
    }
    
}
