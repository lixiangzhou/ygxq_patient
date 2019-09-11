//
//  DrugUsedController.swift
//  patient
//
//  Created by Macbook Pro on 2019/7/4.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift

class DrugUsedController: BaseController {

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "用药记录"
        setUI()
        setBinding()
        viewModel.getData()
    }

    // MARK: - Public Property
    
    // MARK: - Private Property
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private let viewModel = DrugUsedViewModel()
}

// MARK: - UI
extension DrugUsedController {
    override func setUI() {
        tableView.set(dataSource: self, delegate: self)
        tableView.register(cell: TextLeftGrowTextRightCell.self)
        tableView.register(cell: DrugUsedCell.self)
        tableView.backgroundColor = .cf0efef
        tableView.rowHeight = UITableView.automaticDimension
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    override func setBinding() {
        tableView.reactive.reloadData <~ viewModel.dataSourceProperty.map(value: ())
    }
}

// MARK: - Action
extension DrugUsedController {
    @objc private func groupAction(_ gesture: UITapGestureRecognizer) {
        let section = gesture.view!.tag
        var datas = viewModel.dataSourceProperty.value
        var group = viewModel.dataSourceProperty.value[section]
        
        let idx = datas.firstIndex { $0.title == group.title } ?? 0
        datas.remove(at: idx)
        
        group.open = !group.open
        datas.insert(group, at: idx)
        
        viewModel.dataSourceProperty.value = datas
    }
}

// MARK: - Network
extension DrugUsedController {
    
}

// MARK: - Delegate Internal

// MARK: -
// MARK: - UITableViewDataSource, UITableViewDelegate
extension DrugUsedController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.dataSourceProperty.value.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let group = viewModel.dataSourceProperty.value[section]
        return group.open ? group.list.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = viewModel.dataSourceProperty.value[indexPath.section].list[indexPath.row]
        
        switch model {
        case let .drug(drugModel):
            let cell = tableView.dequeue(cell: DrugUsedCell.self, for: indexPath)
            cell.nameLabel.text = drugModel.drugName
            cell.specLabel.text = drugModel.packSpec
            cell.usageLabel.text = drugModel.drugUsage
            return cell
        case let .advice(advice):
            let cell = tableView.dequeue(cell: TextLeftGrowTextRightCell.self, for: indexPath)
            cell.config = viewModel.getConfig("医嘱：")
            cell.leftLabel.text = "医嘱："
            cell.rightLabel.text = advice
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.tag = section
        header.backgroundColor = .cf
        
        let group = viewModel.dataSourceProperty.value[section]
        
        let txtLabel = header.zz_add(subview: UILabel(text: group.title, font: .boldSize(16), textColor: .c3)) as! UILabel
        
        let arrow = UIImageView.defaultRightArrow()
        header.addSubview(arrow)
        arrow.transform = CGAffineTransform(rotationAngle: group.open ? 0 : CGFloat(Double.pi))
        
        txtLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(15)
            maker.centerY.equalToSuperview()
        }
        
        arrow.snp.makeConstraints { (maker) in
            maker.centerY.equalToSuperview()
            maker.right.equalTo(-15)
        }
        
        header.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(groupAction)))
        return header
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 12
    }
}


// MARK: - Delegate External

// MARK: -

// MARK: - Helper
extension DrugUsedController {
    
}

// MARK: - Other
extension DrugUsedController {
    
}

// MARK: - Public
extension DrugUsedController {
    
}

