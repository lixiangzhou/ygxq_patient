//
//  UploadHistoryController.swift
//  patient
//
//  Created by lixiangzhou on 2019/9/4.
//Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift

class UploadHistoryController: BaseController {

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "上传记录"
        setUI()
        viewModel.getData()
        setBinding()
    }

    // MARK: - Public Property
    
    // MARK: - Private Property
    private let tableView = UITableView()
    let viewModel = UploadHistoryViewModel()
}

// MARK: - UI
extension UploadHistoryController {
    override func setUI() {
        tableView.backgroundColor = .cf
        tableView.set(dataSource: self, delegate: self, rowHeight: UITableView.automaticDimension)
        tableView.register(cell: UploadHistoryCell.self)
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    override func setBinding() {
        tableView.reactive.reloadData <~ viewModel.dataSourceProperty.signal.map(value: ())
    }
}

// MARK: - Action
extension UploadHistoryController {
    
}

// MARK: - Network
extension UploadHistoryController {
    
}

// MARK: - Delegate Internal

// MARK: -
// MARK: - UITableViewDataSource, UITableViewDelegate
extension UploadHistoryController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataSourceProperty.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(cell: UploadHistoryCell.self, for: indexPath)
        let model = viewModel.dataSourceProperty.value[indexPath.row]
        
        cell.timeLabel.text = model.title
        
        for (idx, v) in cell.itemViews.enumerated() {
            if idx < model.list.count {
                v.isHidden = false
                v.kf.setImage(with: URL(string: model.list[idx]), placeholder: nil)
            } else {
                v.isHidden = true
            }
        }
        
        return cell
    }
}

// MARK: - Delegate External

// MARK: -

// MARK: - Helper
extension UploadHistoryController {
    
}

// MARK: - Other
extension UploadHistoryController {
    
}

// MARK: - Public
extension UploadHistoryController {
    
}

