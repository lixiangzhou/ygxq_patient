//
//  LongServiceController.swift
//  patient
//
//  Created by lixiangzhou on 2019/8/13.
//Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift

class LongServiceController: BaseController {

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "长期服务"
        setUI()
        setBinding()
        viewModel.getData()
    }

    // MARK: - Public Property
    
    // MARK: - Private Property
    private let tableView = UITableView()
    private let viewModel = LongServiceViewModel()
}

// MARK: - UI
extension LongServiceController {
    override func setUI() {
        tableView.set(dataSource: self, delegate: self, rowHeight: UITableView.automaticDimension)
        tableView.register(cell: LongServiceCell.self)
        tableView.backgroundColor = .cf0efef
        view.addSubview(tableView)
        
        tableView.emptyDataSetView { (emptyView) in
            emptyView.titleLabelString(NSMutableAttributedString(string:"暂无数据"))
        }
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    override func setBinding() {
        tableView.reactive.reloadData <~ viewModel.dataSourceProperty.signal.map(value: ())
    }
}

// MARK: - Delegate Internal

// MARK: -
extension LongServiceController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataSourceProperty.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(cell: LongServiceCell.self, for: indexPath)
        let model = viewModel.dataSourceProperty.value[indexPath.row]
        
        cell.iconView.kf.setImage(with: URL(string: model.imgUrl), placeholder: UIImage(named: "doctor_avator"))
        cell.nameLabel.text = model.realName.isEmpty ? " " : model.realName
        cell.professionLabel.text = model.titleName
        cell.hospitalLabel.text = model.hospitalName

        return cell
    }
}

// MARK: - Delegate External

// MARK: -

// MARK: - Helper
extension LongServiceController {
    
}

// MARK: - Other
extension LongServiceController {
    
}

// MARK: - Public
extension LongServiceController {
    
}

