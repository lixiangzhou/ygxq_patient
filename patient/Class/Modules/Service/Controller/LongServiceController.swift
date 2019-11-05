//
//  LongServiceController.swift
//  patient
//
//  Created by lixiangzhou on 2019/8/16.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift

class LongServiceController: BaseController {

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        setBinding()
        viewModel.getData()
    }

    // MARK: - Public Property
    let viewModel = LongServiceViewModel()
    // MARK: - Private Property
    
    private let iconView = UIImageView(image: UIImage(named: "doctor_avator"))
    private let nameLabel = UILabel(font: .size(18), textColor: .c3, numOfLines: 1)
    private let professionLabel = UILabel(font: .size(15), textColor: .c9)
    private let hospitalLabel = UILabel(font: .size(15), textColor: .c6)
    
    private let servicesView = ThreeColumnView()
    
    private let tableView = UITableView()
}

// MARK: - UI
extension LongServiceController {
    override func setUI() {
        tableView.set(dataSource: self, delegate: self, separatorStyle: .none, rowHeight: UITableView.automaticDimension)
        tableView.register(cell: LongServiceDocInfoCell.self)
        tableView.register(cell: LongServiceListCell.self)
        tableView.register(cell: LongServiceOutlineCell.self)
        tableView.backgroundColor = .cf0efef
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    override func setBinding() {
        tableView.reactive.reloadData <~ viewModel.dataSourceProperty.signal.map(value: ())
        
        viewModel.dataSourceProperty.signal.combineLatest(with: viewModel.hasOpenSerProperty.signal).observeValues { [weak self] result in
            guard let self = self else { return }
            if result.0.isEmpty {
                self.tableView.emptyDataSetView { (view) in
                    let emptyView = UIView()
                    let imgView = emptyView.zz_add(subview: UIImageView(image: UIImage(named: "service_empty")))
                    let descLabel = emptyView.zz_add(subview: UILabel(text: "您还没有购买过该医生的长期服务/\(self.title ?? "")", font: .size(14), textColor: .c6, textAlignment: .center))
                    let buyBtn = emptyView.zz_add(subview: UIButton(title: "立即购买", font: .size(18), titleColor: .cff9a21, backgroundColor: .cf, target: self, action: #selector(self.buyAction)))
                    buyBtn.isHidden = !result.1
                    buyBtn.zz_setBorder(color: .cff9a21, width: 1)
                    buyBtn.zz_setCorner(radius: 6, masksToBounds: true)
                    buyBtn.tag = self.viewModel.index
                    imgView.snp.makeConstraints({ (make) in
                        make.top.centerX.equalToSuperview()
                    })
                    descLabel.snp.makeConstraints({ (make) in
                        make.top.equalTo(imgView.snp.bottom).offset(15)
                        make.left.right.centerX.equalToSuperview()
                    })
                    buyBtn.snp.makeConstraints({ (make) in
                        make.top.equalTo(descLabel.snp.bottom).offset(15)
                        make.centerX.bottom.equalToSuperview()
                        make.size.equalTo(CGSize(width: 110, height: 35))
                    })
                    
                    view.customView(emptyView).verticalOffset(-80)
                }
            } else {
                self.tableView.setEmptyData(title: nil)
            }
            self.tableView.reloadEmptyDataSet()
        }
    }
}

extension LongServiceController {
    @objc private func buyAction() {
        viewModel.getOrder { [weak self] (orderId) in
            let vc = PayController()
            vc.viewModel.orderId = orderId
            vc.viewModel.resultAction = PayViewModel.ResultAction(backClassName: "LongServicesController", type: .longSer)
            self?.push(vc)
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension LongServiceController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataSourceProperty.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = viewModel.dataSourceProperty.value[indexPath.row]
        
        switch model {
        case let .docinfo(model: docModel):
            let cell = tableView.dequeue(cell: LongServiceDocInfoCell.self, for: indexPath)
            
            cell.iconView.kf.setImage(with: URL(string: docModel.imgUrl), placeholder: UIImage(named: "doctor_avator"))
            cell.nameLabel.text = docModel.realName.isEmpty ? " " : docModel.realName
            cell.professionLabel.text = docModel.titleName
            cell.hospitalLabel.text = docModel.hospitalName
            cell.professionLabel.snpUpdateWidth()
            
            return cell
        case let .list(model: list):
            let cell = tableView.dequeue(cell: LongServiceListCell.self, for: indexPath)
            cell.listView.items = list
            for instance in cell.listView.rowInstances {
                instance.label2.textColor = .cf25555
            }
            return cell
        case let .outline(model: model):
            let cell = tableView.dequeue(cell: LongServiceOutlineCell.self, for: indexPath)
            
            cell.titleLabel.text = model.serName
            cell.featureLabel.text = model.serFeature
            cell.contentDescLabel.text = model.serSummary
            
            cell.showFeature = !model.serFeature.isEmpty
            
            return cell
        }
    }
}
