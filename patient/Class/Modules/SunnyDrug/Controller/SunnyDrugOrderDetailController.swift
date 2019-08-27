//
//  SunnyDrugOrderDetailController.swift
//  patient
//
//  Created by lixiangzhou on 2019/8/21.
//Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift

class SunnyDrugOrderDetailController: BaseController {

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "阳光续药"
        setUI()
        setBinding()
        viewModel.getDocData()
        viewModel.getData()
        viewModel.getAssistData()
    }

    // MARK: - Public Property
    let viewModel = SunnyDrugOrderDetailViewModel()
    // MARK: - Private Property
    private let tableView = UITableView()
}

// MARK: - UI
extension SunnyDrugOrderDetailController {
    override func setUI() {
        tableView.set(dataSource: self, delegate: self, separatorStyle: .none, rowHeight: UITableView.automaticDimension)
        tableView.register(cell: SunnyDrugOrderDocInfoCell.self)
        tableView.register(cell: SunnyDrugOrderPatientInfoCell.self)
        tableView.register(cell: SunnyDrugOrderFailCell.self)
        tableView.register(cell: SunnyDrugOrderExpressCell.self)
        tableView.register(cell: SunnyDrugOrderDrugsCell.self)
        tableView.register(cell: SunnyDrugOrderAssistWxInfoCell.self)
        tableView.backgroundColor = .cf0efef
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    override func setBinding() {
        tableView.reactive.reloadData <~ viewModel.dataSourceProperty.signal.map(value: ())
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension SunnyDrugOrderDetailController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataSourceProperty.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = viewModel.dataSourceProperty.value[indexPath.row]
        
        switch model {
        case let .docinfo(model: docModel):
            let cell = tableView.dequeue(cell: SunnyDrugOrderDocInfoCell.self, for: indexPath)
            
            cell.iconView.kf.setImage(with: URL(string: docModel.imgUrl), placeholder: UIImage(named: "doctor_avator"))
            cell.nameLabel.text = docModel.realName.isEmpty ? " " : docModel.realName
            cell.professionLabel.text = docModel.titleName
            cell.hospitalLabel.text = docModel.hospitalName
            cell.professionLabel.snpUpdateWidth()
            
            return cell
        case let .patient(model: model):
            let cell = tableView.dequeue(cell: SunnyDrugOrderPatientInfoCell.self, for: indexPath)
            
            cell.nameView.rightLabel.text = model.realName
            cell.mobileView.rightLabel.text = model.mobile.mobileSecrectString
            cell.addressView.rightLabel.text = model.address
            cell.remarkView.rightLabel.text = model.remark.isEmpty ? "暂无" : model.remark
            
            return cell
        case let .failReason(reason: reason):
            let cell = tableView.dequeue(cell: SunnyDrugOrderFailCell.self, for: indexPath)
            cell.txtLabel.text = reason
            return cell
            
        case let .buyedDrugs(drugs: models, price: price):
            let cell = tableView.dequeue(cell: SunnyDrugOrderDrugsCell.self, for: indexPath)
            cell.txtLabel.text = viewModel.getDrugsString(models)
            cell.priceView.rightLabel.text = "总价 ￥\(price)"
            return cell
            
        case let .express(company: company, expNo: expNo):
            let cell = tableView.dequeue(cell: SunnyDrugOrderExpressCell.self, for: indexPath)
            cell.nameView.rightLabel.text = company
            cell.noView.rightLabel.text = expNo
            return cell
        case let .assist(model: model):
            let cell = tableView.dequeue(cell: SunnyDrugOrderAssistWxInfoCell.self, for: indexPath)
            cell.codeView.kf.setImage(with: URL(string: model.wechatQrCode))
            cell.wxLabel.text = model.wechatId
            return cell
        }
    }
}
