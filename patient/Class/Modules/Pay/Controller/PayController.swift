//
//  PayController.swift
//  patient
//
//  Created by lixiangzhou on 2019/8/28.
//Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift

class PayController: BaseController {

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "支付"
        setUI()
        setBinding()
        viewModel.getData()
    }

    // MARK: - Public Property
    let viewModel = PayViewModel()
    // MARK: - Private Property
    private let tableView = UITableView()
    private let bottomView = PayBottomView()
}

// MARK: - UI
extension PayController {
    override func setUI() {
        tableView.backgroundColor = .cf0efef
        
        tableView.set(dataSource: self, delegate: nil, rowHeight: UITableView.automaticDimension)
        tableView.register(cell: PayListCell.self)
        tableView.register(cell: PayMethodCell.self)
        tableView.register(cell: PayTipCell.self)
        view.addSubview(tableView)
        
        bottomView.payClosure = { [weak self] in
            self?.viewModel.getPayInfo()
        }
        view.addSubview(bottomView)
        
        tableView.contentInset.bottom = UIScreen.zz_tabBar_additionHeight + self.bottomView.zz_height
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        bottomView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(bottomView.zz_height)
            make.bottomOffsetFrom(self)
        }
    }
    
    override func setBinding() {
        tableView.reactive.reloadData <~ viewModel.dataSourceProperty.signal.map(value: ())
                
        viewModel.orderProperty.signal.observeValues { [weak self] (model) in
            self?.bottomView.priceLabel.text = "￥\(model.payAmount)"
        }
        
        viewModel.payInfoProperty.signal.skipNil().observeValues { (model) in
            WXManager.shared.sendPayRequest(model)
        }
        
        WXManager.shared.payRespProperty.signal.skipNil().observeValues { [weak self] (resp) in
            switch resp.errCode {
            case 0:
                if let type = self?.viewModel.resultAction?.type {
//                    switch type {
//                    case .longSer:
//                        let vc = PayResultController()
//                        vc.resultAction = self?.viewModel.resultAction
//                        self?.push(vc)
//                    }
                }
            case -1:
                if !resp.errStr.isEmpty {
                    HUD.show(toast: resp.errStr)
                } else {
                    HUD.show(toast: "支付出错")
                }
            case -2:
                HUD.show(toast: "支付取消")
            default: break
            }
        }
    }
}

// MARK: - Delegate Internal

// MARK: -
extension PayController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataSourceProperty.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = viewModel.dataSourceProperty.value[indexPath.row]
        
        switch model {
        case let .list(name: name, price: price):
            let cell = tableView.dequeue(cell: PayListCell.self, for: indexPath)
            cell.productView.leftLabel.text = name
            cell.productView.rightLabel.text = price
            return cell
        case .method:
            return tableView.dequeue(cell: PayMethodCell.self, for: indexPath)
        case .tip:
            return tableView.dequeue(cell: PayTipCell.self, for: indexPath)
        }
    }
}
