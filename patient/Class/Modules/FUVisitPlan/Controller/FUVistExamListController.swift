//
//  FUVistExamListController.swift
//  patient
//
//  Created by lixiangzhou on 2019/9/6.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift

class FUVistExamListController: BaseController {

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        setBinding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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

        guard let type = viewModel.type else { return }
        
        switch type {
        case .look, .videolookLinkId, .druglookLinkId:
            break
        default:
            let tipLabel = UILabel(text: "温馨提示：请您尽快完成医生向您发送的随访问卷并提交，以便医生给您更全面的回复。", font: .size(13), textColor: .cf25555)
            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.zz_width, height: 50))
            headerView.addSubview(tipLabel)
            tipLabel.snp.makeConstraints { (make) in
                make.top.left.equalTo(15)
                make.right.equalTo(-15)
            }
            tableView.tableHeaderView = headerView
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
        var urlString: String!
        let isFinished = model.isFinished == 1
        
        switch viewModel.type! {
        case .look:
            urlString = NetworkConfig.HTML_SERVE_URL + "/flp-ques.html?id=\(model.id)&view=1"
        case let .video(id: _, linkId: linkId):
            urlString = NetworkConfig.HTML_SERVE_URL + "/question.html?type=\(isFinished ? 2 : 1)&qid=\(model.id)&pid=\(patientId)&vid=\(linkId)&resid=\(model.resultId)&client=2"
        case let .sunnyDrug(id: _, linkId: linkId):
            urlString = NetworkConfig.HTML_SERVE_URL + "/question.html?type=\(isFinished ? 2 : 1)&qid=\(model.id)&pid=\(patientId)&sid=\(linkId)&resid=\(model.resultId)&client=2"
        case .flp:
            urlString = NetworkConfig.HTML_SERVE_URL + "/flp-ques.html?id=\(model.id)\(isFinished ? "&view=1" : "")"
        case let .videolookLinkId(linkId: linkId):
            urlString = NetworkConfig.HTML_SERVE_URL + "/question.html?type=\(isFinished ? 2 : 1)&qid=\(model.id)&pid=\(patientId)&vid=\(linkId)&resid=\(model.resultId)&client=2"
        case let .druglookLinkId(linkId: linkId):
            urlString = NetworkConfig.HTML_SERVE_URL + "/question.html?type=\(isFinished ? 2 : 1)&qid=\(model.id)&pid=\(patientId)&sid=\(linkId)&resid=\(model.resultId)&client=2"
        }
        
        guard let url = URL(string: urlString) else { return }
        let vc = WebController()
        
        vc.url = url
        vc.titleString = isFinished ? "查看问卷" : "填写问卷"
        
        push(vc)
    }
}
