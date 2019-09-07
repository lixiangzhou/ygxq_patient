//
//  FUVistExamListController.swift
//  patient
//
//  Created by lixiangzhou on 2019/9/6.
//Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift

class FUVistExamListController: BaseController {

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        setBinding()
        viewModel.getData()
    }

    // MARK: - Public Property
    
    // MARK: - Private Property
    let viewModel = FUVistExamListViewModel()
    
    private let tableView = UITableView()
}

// MARK: - UI
extension FUVistExamListController {
    override func setUI() {
        tableView.backgroundColor = .cf0efef
        tableView.set(dataSource: self, delegate: self, rowHeight: 82)
        tableView.register(cell: FUVistExamListCell.self)
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
extension FUVistExamListController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataSourceProperty.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(cell: FUVistExamListCell.self, for: indexPath)
        let model = viewModel.dataSourceProperty.value[indexPath.row]
        
        cell.titleLabel.text = model.examName
        cell.statusLabel.text = model.isFinished == 1 ? "已完成" : "未完成"
        
        let color = model.isFinished == 1 ? UIColor.c407cec : UIColor.cf25555
        cell.statusLabel.zz_setBorder(color: color, width: 0.5)
        cell.statusLabel.textColor = color
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = viewModel.dataSourceProperty.value[indexPath.row]
        let urlString = NetworkConfig.HTML_SERVE_URL + "/flp-ques.html?id=\(model.id)&view=1"
        
        guard let url = URL(string: urlString) else { return }
        let vc = WebController()
        vc.url = url
        vc.titleString = "查看问卷"
        push(vc)
    }
}
