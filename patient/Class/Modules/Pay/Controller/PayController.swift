//
//  PayController.swift
//  patient
//
//  Created by lixiangzhou on 2019/8/28.
//  Copyright © 2019 sphr. All rights reserved.
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
            if WXApi.isWXAppInstalled() {
                if let model = self?.viewModel.orderProperty.value, model.isProtocol == false {
                    self?.signName(model)
                } else {
                    self?.viewModel.getPayInfo()
                }
            } else {
                HUD.show(toast: "您还未安装微信")
            }
        }
        view.addSubview(bottomView)
        
        tableView.contentInset.bottom = self.bottomView.zz_height
        
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
                
        viewModel.orderProperty.signal.skipNil().observeValues { [weak self] (model) in
            self?.bottomView.priceLabel.text = "￥\(model.payAmount)"
        }
        
        viewModel.orderProperty.signal.skipNil().skipRepeats { $0.isProtocol == $1.isProtocol }.observeValues { [weak self] (model) in
            if model.isProtocol == false {
                self?.signName(model)
            }
        }
        
        viewModel.payInfoProperty.signal.skipNil().observeValues { (model) in
            WXManager.shared.sendPayRequest(model)
        }
        
        WXManager.shared.payRespProperty.signal.skipNil().observeValues { [weak self] (resp) in
            switch resp.errCode {
            case 0:
                if let type = self?.viewModel.resultAction?.type {
                    switch type {
                    case .singleVideoConsult, .longSer, .sunShineHut:
                        let vc = PayResultController()
                        vc.resultAction = self?.viewModel.resultAction
                        self?.push(vc)
                    case .singleSunnyDrug:
                        let vc = PayResult2Controller()
                        vc.resultAction = self?.viewModel.resultAction
                        vc.viewModel.duid = self?.viewModel.orderProperty.value?.duid ?? 0
                        self?.push(vc)
                    }
                } else {
                    self?.pop()
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
            let cell = tableView.dequeue(cell: PayTipCell.self, for: indexPath)
            cell.serviceClosure = { [weak self] in
                self?.toServicePrototol()
            }
            return cell
        }
    }
}

extension PayController {
    private func signName(_ model: OrderModel) {
        let signNameView = SignNameTipView()
        signNameView.msgLabel.text = "您好，购买服务需要您签字同意我们的《\(appService)》，点击可查看详情。"
        signNameView.msgLabel.addLinks([(string: "《\(appService)》", attributes: [NSAttributedString.Key.foregroundColor: UIColor.c407cec], action: { [weak self] _ in
            self?.toServicePrototol()
            signNameView.hide()
        })])
        signNameView.confirmClosure = { [weak self] img in
            if let img = img {
                self?.viewModel.addProtocol(img)
            }
        }
        
        signNameView.show()
    }
}
