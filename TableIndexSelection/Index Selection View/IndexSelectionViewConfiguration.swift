//
//  IndexSelectionViewConfiguration.swift
//  TableIndexSelection
//
//  Created by Insight Workshop on 12/2/19.
//  Copyright © 2019 Skyway Innovation. All rights reserved.
//

import UIKit

struct IndexSelectionViewConfiguration {
    
    var indexTextColor: UIColor!
    var indexTextFont: UIFont!
    var indexTextColorOnZoom: UIColor!
    var indexTextFontOnZoom: UIFont!
    var indexViewColor: UIColor!
    var indeViewTextColor: UIColor!
    var indexViewTextFont: UIFont!
    
    init(with indexTextColor: UIColor = IndexSelectionViewConstants.indexTextColor,
         and indexTextFont: UIFont = IndexSelectionViewConstants.indexTextFont,
         with indexTextColorOnZoom: UIColor = IndexSelectionViewConstants.indexTextColorOnZoom,
         and indexTextFontOnZoom: UIFont = IndexSelectionViewConstants.indexTextFontOnZoom,
         with indexViewColor: UIColor = IndexSelectionViewConstants.indexViewColor,
         indexViewTextColor: UIColor = IndexSelectionViewConstants.indexViewTextColor,
         indexViewTextFont: UIFont = IndexSelectionViewConstants.indexViewTextFont) {
        self.indexTextColor = indexTextColor
        self.indexTextFont = indexTextFont
        self.indexTextColorOnZoom = indexTextColorOnZoom
        self.indexTextFontOnZoom = indexTextFontOnZoom
        self.indexViewColor = indexViewColor
        self.indeViewTextColor = indexViewTextColor
        self.indexViewTextFont = indexViewTextFont
    }
}
