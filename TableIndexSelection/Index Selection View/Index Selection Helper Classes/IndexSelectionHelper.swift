//
//  IndexSelectionhelper.swift
//  TableIndexSelection
//
//  Created by Insight Workshop on 12/2/19.
//  Copyright © 2019 Skyway Innovation. All rights reserved.
//

import UIKit

class IndexSelectionHelper {
    
    static func isDeviceIpad() -> Bool {
        return UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad
    }
}
