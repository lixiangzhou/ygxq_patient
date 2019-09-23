//
//  HutPackageTimeBuyController.swift
//  patient
//
//  Created by lixiangzhou on 2019/9/20.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift

class HutPackageTimeBuyController: BaseController {

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "套餐详情"
        setUI()
        setBinding()
    }

    // MARK: - Public Property
    let viewModel = HutPackageTimeBuyViewModel()
    
    // MARK: - Private Property
    private let tableView = UITableView()
    private let bottomView = PayBottomView()
}

// MARK: - UI
extension HutPackageTimeBuyController {
    override func setUI() {
        tableView.backgroundColor = .cf0efef
        
        tableView.set(dataSource: self, delegate: nil, rowHeight: UITableView.automaticDimension)
        tableView.register(cell: HutPackageTimeBuyCell.self)
        tableView.register(cell: HutPackageTimeBuyDetailCell.self)
        tableView.register(cell: HutPackageTimeBuyTipCell.self)
        tableView.estimatedRowHeight = 150
        view.addSubview(tableView)
        
        bottomView.payClosure = { [weak self] in
            self?.viewModel.getOrder { (orderId) in
                if let orderId = orderId {
                    let vc = PayController()
                    vc.viewModel.orderId = orderId
                    vc.viewModel.resultAction = PayViewModel.ResultAction(backClassName: self?.zz_className ?? "HutPackageTimeBuyController", type: .sunShineHut)
                    self?.push(vc)
                }
            }
        }
        view.addSubview(bottomView)
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        tableView.contentInset.bottom = 50
        
        bottomView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(bottomView.zz_height)
            make.bottomOffsetFrom(self)
        }
    }
    
    override func setBinding() {
        tableView.reactive.reloadData <~ viewModel.dataSourceProperty.signal.map(value: ())
        viewModel.hutModelProperty.producer.skipNil().startWithValues { [weak self] (model) in
            self?.bottomView.priceLabel.text = "￥\(model.serPrice)"
        }
        viewModel.countProperty.signal.observeValues { [weak self] (v) in
            guard let self = self, let model = self.viewModel.hutModelProperty.value else { return }
            self.bottomView.priceLabel.text = "￥\(model.serPrice * Double(v))"
        }
    }
}

// MARK: - Delegate Internal

// MARK: -
extension HutPackageTimeBuyController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataSourceProperty.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = viewModel.dataSourceProperty.value[indexPath.row]
        
        switch model {
        case let .outline(name: name, price: price):
            let cell = tableView.dequeue(cell: HutPackageTimeBuyCell.self, for: indexPath)
            cell.nameLabel.text = name
            cell.priceLabel.attributedText = price
            viewModel.countProperty <~ cell.countProperty
            return cell
        case let .detail(txt: txt):
            let cell = tableView.dequeue(cell: HutPackageTimeBuyDetailCell.self, for: indexPath)
            cell.txtLabel.text = txt
            return cell
        case .tip:
            return tableView.dequeue(cell: HutPackageTimeBuyTipCell.self, for: indexPath)
        }
    }
}

