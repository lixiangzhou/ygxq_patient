//
//  SunShineHutListController.swift
//  patient
//
//  Created by lixiangzhou on 2019/9/6.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift

class SunShineHutListController: BaseController {

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "服务"
        setUI()
        setBinding()
        viewModel.getData()
    }

    // MARK: - Public Property
    
    // MARK: - Private Property
    private let tableView = UITableView()
    private let viewModel = SunShineHutListViewModel()
}

// MARK: - UI
extension SunShineHutListController {
    override func setUI() {
        tableView.set(dataSource: self, delegate: self, rowHeight: UITableView.automaticDimension)
        tableView.register(cell: SunShineHutListCell.self)
        tableView.backgroundColor = .cf0efef
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    override func setBinding() {
        tableView.reactive.reloadData <~ viewModel.dataSourceProperty.signal.map(value: ())
        
        viewModel.hasBuyECGProperty.signal.observeValues { (value) in
            if value {
                
            } else {
                AlertView.show(title: nil, msg: "请购买心电套餐后再购买服务包", firstTitle: "再想想", secondTitle: "去购买", firstClosure: { alert in
                    alert.hide()
                }, secondClosure: { alert in
                    alert.hide()
                })
            }
        }
    }
}

// MARK: - Delegate Internal

// MARK: -
extension SunShineHutListController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataSourceProperty.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(cell: SunShineHutListCell.self, for: indexPath)
        let model = viewModel.dataSourceProperty.value[indexPath.row]
        
        cell.iconView.kf.setImage(with: URL(string: model.firstImg), placeholder: nil)
        cell.nameLabel.text = model.serName
        cell.featureLabel.text = model.serFeatures
        cell.priceLabel.attributedText = viewModel.getPrice(model)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = viewModel.dataSourceProperty.value[indexPath.row]
        switch model.serCode {
        case "UTOPIA13":
            let vc = HutPackageDetailController()
            vc.viewModel.hutModelProperty.value = model
            push(vc)
            break
        case "UTOPIA14":
            viewModel.canBuy(model)
        default: break
        }
    }
}
