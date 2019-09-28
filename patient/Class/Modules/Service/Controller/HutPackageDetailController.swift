//
//  HutPackageDetailController.swift
//  patient
//
//  Created by lixiangzhou on 2019/9/10.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift

class HutPackageDetailController: BaseController {

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "套餐详情"
        setUI()
        setBinding()
    }

    // MARK: - Public Property
    let viewModel = HutPackageDetailViewModel()
    // MARK: - Private Property
    private let tableView = UITableView()
    private let bottomView = PayBottomView()
}

// MARK: - UI
extension HutPackageDetailController {
    override func setUI() {
        tableView.backgroundColor = .cf0efef
        
        tableView.set(dataSource: self, delegate: nil, rowHeight: UITableView.automaticDimension)
        tableView.register(cell: HutPackageDetailOutlineCell.self)
        tableView.register(cell: HutPackageDetailContentCell.self)
        tableView.register(cell: HutPackageDetailTargetAudienceCell.self)
        tableView.register(cell: HutPackageDetailServiceFlowCell.self)
        tableView.register(cell: HutPackageDetailAddressCell.self)
        tableView.register(cell: HutPackageDetailTipCell.self)
        tableView.estimatedRowHeight = 150
        view.addSubview(tableView)
        
        bottomView.payClosure = { [weak self] in
            self?.viewModel.getOrder { (orderId) in
                if let orderId = orderId {
                    let vc = PayController()
                    vc.viewModel.orderId = orderId
                    vc.viewModel.resultAction = PayViewModel.ResultAction(backClassName: self?.zz_className ?? "HutPackageDetailController", type: .sunShineHut)
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
        viewModel.hutModelProperty.producer.skipNil().startWithValues { (model) in
            self.bottomView.priceLabel.text = "￥\(model.serPrice)"
        }
        tableView.reactive.reloadData <~ viewModel.addressModelProperty.signal.skipRepeats({ (m1, m2) -> Bool in
            if m1 == nil, m2 == nil {
                return true
            } else if m1 == nil, m2 != nil {
                return false
            } else if m1 != nil, m2 == nil {
                return false
            } else {
                return m1!.id == m2!.id
            }
        }).map(value: ())
    }
}

// MARK: - Delegate Internal

// MARK: -
extension HutPackageDetailController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataSourceProperty.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = viewModel.dataSourceProperty.value[indexPath.row]
        
        switch model {
        case let .outline(name: name, time: time, feature: feature, price: price):
            let cell = tableView.dequeue(cell: HutPackageDetailOutlineCell.self, for: indexPath)
            cell.titleLabel.text = name
            cell.priceLabel.attributedText = price
            cell.timeLabel.text = "有效期：\(time)年"
            cell.featureLabel.text = "产品特点：\(feature)"
            return cell
        case let .content(contents: contents, detail: detail, pic: pic):
            let cell = tableView.dequeue(cell: HutPackageDetailContentCell.self, for: indexPath)
            cell.contents = contents
            cell.detailLabel.text = detail
            cell.iconView.setImage(with: URL(string: pic))
            return cell
        case let .targetAudience(models: models):
            let cell = tableView.dequeue(cell: HutPackageDetailTargetAudienceCell.self, for: indexPath)
            cell.models = models
            return cell
        case let .serviceFlow(progress):
            let cell = tableView.dequeue(cell: HutPackageDetailServiceFlowCell.self, for: indexPath)
            cell.progress = progress
            return cell
        case .address:
            let cell = tableView.dequeue(cell: HutPackageDetailAddressCell.self, for: indexPath)
            cell.getDefault()
            viewModel.addressModelProperty <~ cell.addressView.viewModel.addressModelProperty
            return cell
        case .tip:
            let cell = tableView.dequeue(cell: HutPackageDetailTipCell.self, for: indexPath)
            return cell
        }
    }
}
