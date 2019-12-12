//
//  IndexSelectionView.swift
//  Ziing
//
//  Created by Ashwin Shrestha on 7/5/19.
//  Copyright © 2019 Fabian E. Pezet Vila. All rights reserved.
//

import UIKit

protocol IndexSelectionViewDelegate: class {
    func canScroll(toItemWith prefix: String) -> Bool
    func scrollToIndex(with prefix: String)
    func getPopOverPosition() -> CGPoint
}

class IndexSelectionView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet var tableView: UITableView!
    
    private lazy var indexIndicatorLabel = UILabel()
    private var charIndexes = [String]()
    private var previousSelectedIndex: IndexPath?
    private lazy var indexViewConfiguration = IndexSelectionViewConfiguration()
    weak var delegate: IndexSelectionViewDelegate?
    
    private var width: CGFloat = IndexSelectionHelper.isDeviceIpad() ? 150.0 : 100.0
    
    var isIndexSelectionShowing = false {
        didSet {
            indexIndicatorLabel.isHidden = !isIndexSelectionShowing
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        commonInit()
    }
    
    func commonInit() {
        loadNib()
        setView(contentView)
        setUpData()
        setUpTable()
    }
    
    func  setUpIndicatorView(with configuration: IndexSelectionViewConfiguration = IndexSelectionViewConfiguration()) {
        indexViewConfiguration = configuration
        indexIndicatorLabel.removeFromSuperview()
        indexIndicatorLabel = UILabel(frame: CGRect(origin: .zero, size: CGSize(width: width, height: width)))
        indexIndicatorLabel.textAlignment = .center
        indexIndicatorLabel.textColor = .white
        indexIndicatorLabel.layer.cornerRadius =  width/2.0
        indexIndicatorLabel.layer.masksToBounds = true
        indexIndicatorLabel.backgroundColor = indexViewConfiguration.indexViewColor
        indexIndicatorLabel.isHidden = true
        indexIndicatorLabel.font = indexViewConfiguration.indexViewTextFont
        guard let view = IndexSelectionViewHelper.getParentControllerBaseView(for: self)
            else { return }
        view.addSubview(indexIndicatorLabel)
        indexIndicatorLabel.center = delegate?.getPopOverPosition() ?? .zero
    }
    
    private func setUpData() {
        charIndexes.append("#")
        for i in 65..<91 {
            charIndexes.append(String(UnicodeScalar(UInt8(i))))
        }
    }
    
    func setView(_ contentView: UIView) {
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        contentView.frame = bounds
        addSubview(contentView)
    }
    
    func loadNib(){
        Bundle.main.loadNibNamed("IndexSelectionView", owner: self, options: nil)
    }
    
    private func setUpTable() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.canCancelContentTouches = false
        tableView.register(UINib(nibName: "IndexSelectionTableViewCell",
                                 bundle: nil),
                           forCellReuseIdentifier: "IndexSelectionTableViewCell")
        addLongPressGesture()
    }

}

extension IndexSelectionView {
    
    func addLongPressGesture() {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressGestureHandler(_:)))
        longPressGesture.minimumPressDuration = 0.2
        tableView.addGestureRecognizer(longPressGesture)
    }
    
    @objc func longPressGestureHandler(_ gesture: UILongPressGestureRecognizer) {
        let locationPoint = gesture.location(in: tableView)
        switch gesture.state {
            case .possible: return
            case .began: handleGestureBegan(inLocation: locationPoint)
            case .changed: handleGestureChanged(inLocation: locationPoint)
            case .ended: handleGestureEnded(inLocation: locationPoint)
            case .cancelled: return
            case .failed: return
        }
    }
    
    func handleGestureBegan(inLocation locationPoint: CGPoint) {
        guard let indexPath = getIndexPath(locationPoint),
            let cell = tableView.cellForRow(at: indexPath) as? IndexSelectionTableViewCell else { return }
        previousSelectedIndex = indexPath
        isIndexSelectionShowing = true
        cell.setIsSelected(flag: true)
    }
    
    func handleGestureChanged(inLocation locationPoint: CGPoint) {
        guard let indexPath = getIndexPath(locationPoint),
            let previousIndex = previousSelectedIndex,
            let oldCell = tableView.cellForRow(at: previousIndex) as? IndexSelectionTableViewCell,
            let currentCell = tableView.cellForRow(at: indexPath) as? IndexSelectionTableViewCell
            else { return }
        if previousIndex != indexPath {
            oldCell.setIsSelected(flag: false)
            currentCell.setIsSelected(flag: true)
            previousSelectedIndex = indexPath
            Haptic.selection.generate()
            scrollTo(indexPath: indexPath)
        }
    }
    
    func handleGestureEnded(inLocation location: CGPoint) {
        guard let indexPath = getIndexPath(location) else {
            isIndexSelectionShowing = false
            tableView.reloadData()
            return
        }
            guard let previousIndex = previousSelectedIndex,
            let oldCell = tableView.cellForRow(at: previousIndex) as? IndexSelectionTableViewCell,
            let currentCell = tableView.cellForRow(at: indexPath) as? IndexSelectionTableViewCell
            else { return }
        oldCell.setIsSelected(flag: false)
        currentCell.setIsSelected(flag: false)
        isIndexSelectionShowing = false
    }
    
    private func getIndexPath(_ point: CGPoint) -> IndexPath? {
        return tableView.indexPathForRow(at: point)
    }
    
    private func scrollTo(indexPath: IndexPath) {
        if !(charIndexes.indices.contains(indexPath.row)) { return }
        let indexChar = charIndexes[indexPath.row]
        indexIndicatorLabel.text = indexChar
        guard let delegate = delegate else {
            fatalError("Delegate not set")
        }
        if delegate.canScroll(toItemWith: indexChar) {
            delegate.scrollToIndex(with: indexChar)
        } else {
            scrollTo(indexPath: IndexPath(item: indexPath.row + 1 , section: 0))
        }
    }
    
    private func animateIndexIndicatorLabel(at indexPath: IndexPath) {
         let cell = self.tableView.cellForRow(at: indexPath) as? IndexSelectionTableViewCell
         cell?.setIsSelected(flag: true)
         self.tableView.reloadRows(at: [indexPath], with: .fade)
     }
    
}


extension IndexSelectionView: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return charIndexes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: IndexSelectionTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.configuration = indexViewConfiguration
        cell.indexLabel.text = charIndexes[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        animateIndexIndicatorLabel(at: indexPath)
        scrollTo(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.bounds.size.height / CGFloat(charIndexes.count)
    }
    
}
