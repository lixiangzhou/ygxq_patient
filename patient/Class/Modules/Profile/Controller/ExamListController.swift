//
//  ExamListController.swift
//  patient
//
//  Created by Macbook Pro on 2019/6/21.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift

class ExamListController: BaseController {
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setBinding()
        viewModel.getData()
    }
    
    // MARK: - Public Property
    
    // MARK: - Private Property
    private let viewModel = ExamListViewModel()
    private let tableView = UITableView()
}

// MARK: - UI
extension ExamListController {
    override func setUI() {
        tableView.set(dataSource: self, delegate: self)
        tableView.register(cell: ExamListCell.self)
        tableView.backgroundColor = .cf0efef
        tableView.rowHeight = UITableView.automaticDimension
        view.addSubview(tableView)

        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    override func setBinding() {
        tableView.reactive.reloadData <~ viewModel.dataSourceProperty.signal.skipRepeats().map(value: ())
        tableView.reactive.emptyDataString <~ viewModel.dataSourceProperty.signal.map { $0.isEmpty ? "暂无数据" : nil }
    }
}

// MARK: - Delegate Internal

// MARK: -
// MARK: - UITableViewDataSource, UITableViewDelegate
extension ExamListController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.dataSourceProperty.value.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataSourceProperty.value[section].list.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(cell: ExamListCell.self, for: indexPath)

        let list = viewModel.dataSourceProperty.value[indexPath.section].list
        let model = list[indexPath.row]

        cell.nameLabel.text = model.examName

        cell.typeLabel.text = viewModel.getTypeString(model)
        cell.typeLabel.isHidden = true//viewModel.getTypeString(model).isEmpty
        
        cell.bottomLine.isHidden = list.count - 1 == indexPath.row

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = viewModel.dataSourceProperty.value[indexPath.section].list[indexPath.row]
        
        ActionCollecter.sendData(lev: "15")
        
        var urlString: String?
        switch model.type {
        case "video", "drug", "tel":
            urlString = NetworkConfig.HTML_SERVE_URL + "/question.html?type=2&pid=\(patientId)&resid=\(model.resultId)&client=2&qid=\(model.id)"
        case "flp":
            urlString = NetworkConfig.HTML_SERVE_URL + "/flp-ques.html?id=\(model.resultId)&view=1"
        default:
            break
        }
        
        guard let url = URL(string: urlString ?? "") else { return }
        let vc = WebController()
        vc.url = url
        vc.titleString = "查看问卷"
        push(vc)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .cf

        view.addBottomLine(left: 15, right: 15)

        let txt = viewModel.dataSourceProperty.value[section].title

        let timeLabel = UILabel(text: txt, font: .size(15), textColor: .c6)
        view.addSubview(timeLabel)

        timeLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(15)
        }
        return view
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .cf0efef
        return view
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
}

