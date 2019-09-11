//
//  FUVisitPlanController.swift
//  patient
//
//  Created by lixiangzhou on 2019/9/6.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift

class FUVisitPlanController: BaseController {

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "随访计划"
        setUI()
        setBinding()
        viewModel.getData()
    }

    // MARK: - Public Property
    
    // MARK: - Private Property
    private let viewModel = FUVisitPlanViewModel()
    
    private let tableView = UITableView()
}

// MARK: - UI
extension FUVisitPlanController {
    override func setUI() {
        tableView.backgroundColor = .cf0efef
        tableView.set(dataSource: self, rowHeight: UITableView.automaticDimension)
        tableView.register(cell: FUVisitPlanCell.self)
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    override func setBinding() {
        tableView.reactive.reloadData <~ viewModel.dataSourceProperty.signal.map(value: ())
    }
}

// MARK: - Delegate Internal

// MARK: -
// MARK: - UITableViewDataSource, UITableViewDelegate
extension FUVisitPlanController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataSourceProperty.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(cell: FUVisitPlanCell.self, for: indexPath)
        let model = viewModel.dataSourceProperty.value[indexPath.row]
        cell.model = model
        cell.rowClosure = { [weak self] type in
            switch type {
            case .materials:
                let vc = PictureListController()
                vc.title = "完善资料详情"
                vc.viewModel.getDataFromSelf = false
                vc.viewModel.dataSourceProperty.value = self?.viewModel.getImgs(model) ?? []
                self?.push(vc)
            case .lookFlpExams:
                let vc = FUVistExamListController()
                vc.title = "查看随访问卷"
                vc.viewModel.type = .look(id: model.id)
                self?.push(vc)
            }
        }
        return cell
    }
}
