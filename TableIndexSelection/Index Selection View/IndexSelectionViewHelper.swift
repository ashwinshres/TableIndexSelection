//
//  IndexSelectionViewHelper.swift
//  PestControl
//
//  Created by Ashwin Shrestha on 7/6/19.
//  Copyright © 2019 Lucid Pesty. All rights reserved.
//

import UIKit

open class IndexSelectionViewHelper {
    
    static func getParentControllerBaseView(for view: UIView) -> UIView? {
        return IndexSelectionViewHelper.getPrentController(for: view)?.view
    }
    
    static func getPrentController(for view: UIView) -> UIViewController? {
        var parentViewController: UIViewController? {
            var parentResponder: UIResponder? = view
            while parentResponder != nil {
                parentResponder = parentResponder!.next
                if let viewController = parentResponder as? UIViewController {
                    return viewController
                }
            }
            return nil
        }
        return parentViewController
    }
    
    static func getCenter(for view: UIView,
                          withRespectToIts parent: UIView,
                          on parentControllerView: UIView) -> CGPoint {
        let destinationPosition = parentControllerView.convert(view.frame, from: parent)
        let destinationCenterX = destinationPosition.origin.x + (destinationPosition.size.width / 2.0)
        let destinationCenterY = destinationPosition.origin.y + (destinationPosition.size.height / 2.0)
        return CGPoint(x: destinationCenterX, y: destinationCenterY)
    }
    
}
