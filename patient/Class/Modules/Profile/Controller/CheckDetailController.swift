//
//  CheckDetailController.swift
//  patient
//
//  Created by Macbook Pro on 2019/7/3.
//Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift

class CheckDetailController: BaseController {

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "检查详情"
        setUI()
        setBinding()
        viewModel.getData(id)
    }

    // MARK: - Public Property
    var id = 0
    
    // MARK: - Private Property
    private let tableView = UITableView()
    private let viewModel = CheckDetailViewModel()
}

// MARK: - UI
extension CheckDetailController {
    override func setUI() {
        tableView.set(dataSource: self, delegate: self)
        tableView.register(cell: TextLeftRightCell.self)
        tableView.register(cell: CheckDetailCheckItemsCell.self)
        tableView.backgroundColor = .cf0efef
        tableView.rowHeight = UITableView.automaticDimension
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    override func setBinding() {
        tableView.reactive.reloadData <~ viewModel.dataSourceProperty.map(value: ())
    }
}

// MARK: - Action
extension CheckDetailController {
    
}

// MARK: - Network
extension CheckDetailController {
    
}

// MARK: - Delegate Internal

// MARK: -
// MARK: - UITableViewDataSource, UITableViewDelegate
extension CheckDetailController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataSourceProperty.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let record = viewModel.dataSourceProperty.value[indexPath.row]
        
        if record.results.isEmpty {
            let cell = tableView.dequeue(cell: TextLeftRightCell.self, for: indexPath)
            
            cell.config = TextLeftRightViewConfig(rightFont: .boldSize(16))
            cell.leftLabel.text = record.title
            cell.rightLabel.text = record.subTitle
            
            return cell
        } else {
            let cell = tableView.dequeue(cell: CheckDetailCheckItemsCell.self, for: indexPath)
            cell.itemsView.items = record.results
            return cell
        }
    }
}
// MARK: - Delegate External

// MARK: -

// MARK: - Helper
extension CheckDetailController {
    
}

// MARK: - Other
extension CheckDetailController {
    
}

// MARK: - Public
extension CheckDetailController {
    
}

