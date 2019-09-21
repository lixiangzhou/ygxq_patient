//
//  CaseDetailController.swift
//  patient
//
//  Created by Macbook Pro on 2019/7/3.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift

class CaseDetailController: BaseController {

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "病历详情"
        setUI()
        setBinding()
        viewModel.getData(id)
    }

    // MARK: - Public Property
    var id = 0
    
    // MARK: - Private Property
    private let tableView = UITableView()
    private let viewModel = CaseDetailViewModel()
}

// MARK: - UI
extension CaseDetailController {
    override func setUI() {
        tableView.set(dataSource: self, delegate: self)
        tableView.register(cell: TextLeftGrowTextRightCell.self)
        tableView.register(cell: CaseDetailOpCell.self)
        tableView.backgroundColor = .cf0efef
        tableView.rowHeight = UITableView.automaticDimension
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    override func setBinding() {
        tableView.reactive.reloadData <~ viewModel.dataSourceProperty.map(value: ())
        viewModel.caseModelProperty.producer.startWithValues { [weak self] (m) in
            guard let self = self, let m = m, m.imgs.count > 0 else { return }
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "查看原图", target: self, action: #selector(self.lookPicAction))
        }
    }
}

// MARK: - Action
extension CaseDetailController {
    @objc private func lookPicAction() {
        PhotoBrowser.showNetImage(numberOfItems: { [weak self] () -> Int in
            return self?.viewModel.caseModelProperty.value?.imgs.count ?? 0
            }, placeholder: { (index) -> UIImage? in
                return nil
        }, autoloadURLString: { [weak self] (index) -> String? in
            return self?.viewModel.caseModelProperty.value?.imgs[index].url
        })
    }
}

// MARK: - Delegate Internal

// MARK: -
// MARK: - UITableViewDataSource, UITableViewDelegate
extension CaseDetailController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataSourceProperty.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let record = viewModel.dataSourceProperty.value[indexPath.row]

        if record.title != "冠状动脉造影狭窄" {
            let cell = tableView.dequeue(cell: TextLeftGrowTextRightCell.self, for: indexPath)
            
            cell.config = TextLeftGrowTextRightViewConfig(leftTopPadding: 15, leftBottomPadding: 15, rightTopPadding: 15, rightBottomPadding: 15, rightFont: .boldSize(16))
            cell.leftLabel.text = record.title
            cell.rightLabel.text = record.subTitle
            
            return cell
        } else {
            let cell = tableView.dequeue(cell: CaseDetailOpCell.self, for: indexPath)
            cell.titleLabel.text = record.title
            cell.opView.items = record.items
            return cell
        }
    }
}
