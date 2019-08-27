//
//  AddressListController.swift
//  patient
//
//  Created by Macbook Pro on 2019/7/1.
//Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift

class AddressListController: BaseController {

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "地址管理"
        setUI()
        setBinding()
        viewModel.getList()
    }

    // MARK: - Public Property
    
    // MARK: - Private Property
    private let tableView = UITableView()
    private let viewModel = AddressListViewModel()
}

// MARK: - UI
extension AddressListController {
    override func setUI() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "新增地址", target: self, action: #selector(addAddressAction))
        
        tableView.backgroundColor = .cf0efef
        tableView.set(dataSource: self, delegate: self, rowHeight: UITableView.automaticDimension)
        tableView.register(cell: AddressListCell.self)
        view.addSubview(tableView)
        
        tableView.emptyDataSetView { (emptyView) in
            emptyView.titleLabelString(NSMutableAttributedString(string:"暂无数据"))
        }
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    override func setBinding() {
        tableView.reactive.reloadData <~ viewModel.dataSourceProperty.skipRepeats().map(value: ())
    }
}

// MARK: - Action
extension AddressListController {
    @objc private func addAddressAction() {
        toUpdateAddress(.add, model: nil)
    }
}

// MARK: - Delegate Internal

// MARK: -
// MARK: - UITableViewDataSource, UITableViewDelegate
extension AddressListController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataSourceProperty.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(cell: AddressListCell.self, for: indexPath)
        let model = viewModel.dataSourceProperty.value[indexPath.row]
        
        cell.nameLabel.text = model.consignee
        cell.mobileLabel.text = model.mobile.mobileSecrectString
        cell.addressLabel.text = model.district + model.address
        cell.defaultView.isHidden = !model.isDefault
        
        cell.editClosure = { [unowned self] in
            self.toUpdateAddress(.update, model: model)
        }
        
        return cell
    }
}

// MARK: - Delegate External

// MARK: -

// MARK: - Helper
extension AddressListController {
    private func toUpdateAddress(_ mode: AddressEditController.Mode, model: AddressModel?) {
        let vc = AddressEditController()
        vc.mode = mode
        vc.addressModel = model
        vc.completionClosure = { [unowned self] in
            self.viewModel.getList()
        }
        push(vc)
    }
}

// MARK: - Other
extension AddressListController {
    
}

// MARK: - Public
extension AddressListController {
    
}

