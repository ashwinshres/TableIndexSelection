//
//  IndexSelectionProtocols.swift
//  TableIndexSelection
//
//  Created by Insight Workshop on 12/2/19.
//  Copyright © 2019 Skyway Innovation. All rights reserved.
//

import UIKit

protocol ReusableView: class {
    static var defaultReuseIdentififer: String { get }
}

extension ReusableView where Self: UIView {
    static var defaultReuseIdentififer: String {
        return String(describing: self)
    }
}

protocol NibLoadableView: class {
    static var nibName: String { get }
}

extension NibLoadableView where Self: UIView {
    static var nibName: String {
        return String(describing: self)
    }
}
