//
//  MineController.swift
//  patient
//
//  Created by Macbook Pro on 2019/5/21.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class MineController: BaseController {

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "我的"
        setUI()
    }

    // MARK: - Properties
    private let tableView = UITableView()
    private let viewModel = MineViewModel()
}

// MARK: - UI
extension MineController {
    private func setUI() {
        view.addSubview(tableView)
        
        tableView.register(cell: TextTableViewCell.self)
        tableView.set(dataSource: self, delegate: self)
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}

extension MineController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(cell: TextTableViewCell.self, for: indexPath)
        cell.titleLabel.text = viewModel.dataSource[indexPath.row].rawValue
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
