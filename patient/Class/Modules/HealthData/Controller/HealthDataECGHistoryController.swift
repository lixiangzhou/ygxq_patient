//
//  HealthDataECGHistoryController.swift
//  patient
//
//  Created by lixiangzhou on 2019/10/15.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift

class HealthDataECGHistoryController: BaseController {

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "监测历史"
        setUI()
        setBinding()
        viewModel.getData()
    }

    // MARK: - Public Property
    let viewModel = HealthDataECGHistoryViewModel()
    // MARK: - Private Property
    private let tableView = UITableView()
    
}

// MARK: - UI
extension HealthDataECGHistoryController {
    override func setUI() {
        tableView.set(dataSource: self, delegate: self, rowHeight: 50)
        tableView.register(cell: HealthDataEcgHistoryCell.self)
        tableView.backgroundColor = .cf0efef
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    override func setBinding() {
        tableView.reactive.reloadData <~ viewModel.dataSourceProperty.signal.map(value: ())
        
        viewModel.dataSourceProperty.signal.observeValues { [weak self] (values) in
            guard let self = self else { return }
            
            if values.isEmpty {
                self.tableView.emptyDataSetView { (view) in
                    let emptyView = UIView()
                    let imgView = emptyView.zz_add(subview: UIImageView(image: UIImage(named: "healthdata_history_empty")))
                    let descLabel = emptyView.zz_add(subview: UILabel(text: "您还没有做过心电监测，快去监测一下吧", font: .boldSize(15), textColor: .c407cec, textAlignment: .center))
                    let buyBtn = emptyView.zz_add(subview: UIButton(title: "现在就去", font: .size(16), titleColor: .cff9a21, backgroundColor: .cf, target: self, action: #selector(self.monitorAction)))
                    buyBtn.zz_setBorder(color: .cff9a21, width: 1)
                    buyBtn.zz_setCorner(radius: 6, masksToBounds: true)
                    
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

// MARK: - Action
extension HealthDataECGHistoryController {
    @objc private func monitorAction() {
        let vc = HealthDataECGBasinInfoController()
        vc.viewModel.backClass = "HealthDataECGShowController"
        push(vc)
    }
}

// MARK: - Delegate Internal

// MARK: - UITableViewDataSource, UITableViewDelegate
extension HealthDataECGHistoryController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.dataSourceProperty.value.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataSourceProperty.value[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(cell: HealthDataEcgHistoryCell.self, for: indexPath)
        let model = viewModel.dataSourceProperty.value[indexPath.section][indexPath.row]
        cell.model = model
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let time = viewModel.dataSourceProperty.value[section].first?.createTime.toTime(format: "yyyy-MM-dd") {
            return UILabel(text: time, font: .size(15), textColor: .c6, textAlignment: .center)
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if viewModel.dataSourceProperty.value[section].first?.createTime.toTime(format: "yyyy-MM-dd") != nil {
            return 45
        }
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = viewModel.dataSourceProperty.value[indexPath.section][indexPath.row]
        let vc = HealthDataECGDetailController()
        vc.viewModel.dataProperty.value = model
        push(vc)
    }
}

