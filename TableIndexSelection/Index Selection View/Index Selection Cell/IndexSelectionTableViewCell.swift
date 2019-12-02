//
//  SideIndexTableViewCell.swift
//  Ziing
//
//  Created by Ashwin Shrestha on 7/5/19.
//  Copyright © 2019 Lucid Pesty. All rights reserved.
//

import UIKit

class IndexSelectionTableViewCell: UITableViewCell, ReusableView, NibLoadableView {

    @IBOutlet var indexLabel: UILabel!
    @IBOutlet var wrapperView: UIView!
    
    var configuration: IndexSelectionViewConfiguration = IndexSelectionViewConfiguration() {
        didSet {
            setIsSelected(flag: false)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func setIsSelected(flag: Bool) {
        indexLabel.font = flag ? configuration.indexTextFontOnZoom : configuration.indexTextFont
        indexLabel.textColor = flag ? configuration.indexTextColorOnZoom : configuration.indexTextColor
    }

}
