//
//  CaseDetailController.swift
//  patient
//
//  Created by Macbook Pro on 2019/7/3.
//Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift

class CaseDetailController: BaseController {

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "病例详情"
        setUI()
        setBinding()
        viewModel.getData(id)
    }

    // MARK: - Public Property
    var id = 0
    
    // MARK: - Private Property
    private let tableView = UITableView()
    private let viewModel = CaseDetailViewModel()
}

// MARK: - UI
extension CaseDetailController {
    override func setUI() {
        tableView.set(dataSource: self, delegate: self)
        tableView.register(cell: TextLeftGrowTextRightCell.self)
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
extension CaseDetailController {
    
}

// MARK: - Network
extension CaseDetailController {
    
}

// MARK: - Delegate Internal

// MARK: -
// MARK: - UITableViewDataSource, UITableViewDelegate
extension CaseDetailController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataSourceProperty.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(cell: TextLeftGrowTextRightCell.self, for: indexPath)
        let record = viewModel.dataSourceProperty.value[indexPath.row]
        
        cell.config = TextLeftGrowTextRightViewConfig(leftTopPadding: 15, leftBottomPadding: 15, rightTopPadding: 15, rightBottomPadding: 15, rightFont: .boldSize(16))
        cell.leftLabel.text = record.title
        cell.rightLabel.text = record.subTitle
        
        return cell
    }
}

// MARK: - Delegate External

// MARK: -

// MARK: - Helper
extension CaseDetailController {
    
}

// MARK: - Other
extension CaseDetailController {
    
}

// MARK: - Public
extension CaseDetailController {
    
}

