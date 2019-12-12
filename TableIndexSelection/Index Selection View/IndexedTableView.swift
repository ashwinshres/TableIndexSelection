//
//  IndexedTableView.swift
//  TableIndexSelection
//
//  Created by Insight Workshop on 12/4/19.
//  Copyright © 2019 Skyway Innovation. All rights reserved.
//

import UIKit

open class IndexedTableView: UITableView {
    
    public enum IndexViewPosition {
        case left
        case right
        case none
    }
    
    private lazy var indexView: IndexSelectionView = IndexSelectionView(frame: CGRect(origin: .zero, size: .zero))
    open var indexPosition: IndexViewPosition = .left
    private var indexViewWidth: CGFloat = 0.0
    
    func configureIndexedTable(on indexPosition: IndexViewPosition,
                               ofWidth width: CGFloat,
                               withDelegate indexScollDelegate: IndexSelectionViewDelegate? = nil,
                               and indices: Set<Character>) {
        self.indexPosition = indexPosition
        self.indexViewWidth = width
        indexView.delegate = indexScollDelegate
        setViewPositions()
        if indexPosition == .none { return }
        setUpIndexSelectionView()
        setupCharacterIndices(with: indices)
        indexView.tableView.reloadData()
    }
    
    /// Appends character indices to ```charIndexes``` variable of ```indexView```.
    /// - Parameter indices: The indices extracted from ```dataSource```.
    private func setupCharacterIndices(with indices: Set<Character>) {
        indexView.charIndexes.append("#")
        for index in indices
            where index.asciiValue! >= UInt8(65) && index.asciiValue! < UInt8(91) {
                indexView.charIndexes.append(String(index))
        }
    }
    
    private func setViewPositions() {
        var indexViewX: CGFloat = 0.0
        switch indexPosition {
        case .none:
            return
        case .left:
            indexViewX = 0.0
            separatorInset.left = indexViewWidth
        case .right:
            indexViewX = frame.width - indexViewWidth
            separatorInset.right = indexViewX
        }
        
        indexView.frame = bounds
        indexView.frame.origin.x = indexViewX
        indexView.frame.size.width = indexViewWidth
        let view = IndexSelectionViewHelper.getParentControllerBaseView(for: self)
        view!.addSubview(indexView)
    }
    
    private func setUpIndexSelectionView() {
        indexView.setUpIndicatorView(with: IndexSelectionViewConfiguration())
    }
    
    private func isPrefixAlpha(prefix: String) -> Bool {
        let alphaRegEx = "[A-Za-z]+"
        let predicate = NSPredicate(format:"SELF MATCHES %@", alphaRegEx)
        return predicate.evaluate(with: prefix)
    }
    
    open func scrollTo(indexPath: IndexPath) {
        scrollToRow(at: indexPath, at: .top, animated: true)
    }
    
}
