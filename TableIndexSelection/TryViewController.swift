//
//  TryViewController.swift
//  TableIndexSelection
//
//  Created by Insight Workshop on 12/4/19.
//  Copyright © 2019 Skyway Innovation. All rights reserved.
//

import UIKit

class TryViewController: UIViewController {

    @IBOutlet var tableView: IndexedTableView!
    var dataSource = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        dataSource.append(contentsOf: loadRandomData(100,of: 10))
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
    
    private func setUpTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.configureIndexedTable(on: .left, ofWidth: 70.0, withDelegate: self)
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
}

extension TryViewController: UITableViewDataSource, UITableViewDelegate, IndexSelectionViewDelegate {
    
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
            tableView.scrollTo(indexPath: IndexPath(row: mainDataFirstIndex, section: 0))
        } else {
            tableView.scrollTo(indexPath: IndexPath(row: NSNotFound, section: 0))
        }
    }
    
}
