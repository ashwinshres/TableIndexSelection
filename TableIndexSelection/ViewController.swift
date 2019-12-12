//
//  ViewController.swift
//  TableIndexSelection
//
//  Created by Insight Workshop on 7/15/19.
//  Copyright © 2019 Skyway Innovation. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var indexSelectionViewWidth: NSLayoutConstraint!
    @IBOutlet var indexSelectionView: IndexSelectionView!
    @IBOutlet var tableView: UITableView!
    
    var dataSource = [String]()
    var indexIndicators = Set<Character>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        dataSource.append(contentsOf: loadRandomData(100,of: 10))
        extractCharactersForIndexIndicator()
        setUpTableView()
    }
    
    private func loadRandomData(_ count: Int, of length: Int) -> [String] {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-_+=!@#$%^&*"
        var strings = [String]()
        for _ in 0..<count {
            strings.append(String((0..<length).map{ _ in letters.randomElement()! }))
        }
        return strings.sorted(by: { (string1, string2) -> Bool in
            return string1.lowercased() < string2.lowercased()
        })
    }

    private func extractCharactersForIndexIndicator() {
        for data in dataSource {
            indexIndicators.insert(data.first!)
        }
        print(indexIndicators)
    }
    
    private func setUpTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
    }

}

extension ViewController: IndexSelectionViewDelegate {
    
    func getPopOverPosition() -> CGPoint {
        return CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY)
    }
    
    func canScroll(toItemWith prefix: String) -> Bool {
        if prefix.isValidAlphabetOnly {
            guard let _ = dataSource.firstIndex(where: { (item) -> Bool in
                return item.lowercased().hasPrefix(prefix.lowercased())
            }) else { return false }
        }
        return true
    }
    
    func scrollToIndex(with prefix: String) {
        if prefix.isValidAlphabetOnly {
            guard let mainDataFirstIndex = dataSource.firstIndex(where: { (item) -> Bool in
                return item.lowercased().hasPrefix(prefix.lowercased())
            }) else {
                return
            }
            scrollTo(indexPath: IndexPath(row: mainDataFirstIndex, section: 0))
        } else {
            scrollTo(indexPath: IndexPath(row: NSNotFound, section: 0))
        }
    }
    
    private func updateIndexSelectionView() {
        UIView.animate(withDuration: 0.25) {
            self.indexSelectionViewWidth.constant = self.dataSource.isEmpty ? 0.0 : 50.0
            self.view.layoutIfNeeded()
        }
    }
    
    private func scrollTo(indexPath: IndexPath) {
        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    
    private func isPrefixAlpha(prefix: String) -> Bool {
        return prefix.isValidAlphabetOnly
    }
    
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = dataSource[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
}

extension String {
    
    var isValidAlphabetOnly: Bool {
        let alphaRegEx = "[A-Za-z]+"
        let predicate = NSPredicate(format:"SELF MATCHES %@", alphaRegEx)
        return predicate.evaluate(with: self)
    }
    
}

