//
//  BindedDoctorsController.swift
//  patient
//
//  Created by lixiangzhou on 2019/8/27.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift

class BindedDoctorsController: BaseController {

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "复诊 / 购药"
        setUI()
        setBinding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getData()
    }
    
    // MARK: - Public Property
    
    // MARK: - Private Property
    private let tableView = UITableView()
    private let viewModel = BindedDoctorsViewModel()
}

// MARK: - UI
extension BindedDoctorsController {
    override func setUI() {
        setRightBarItem(title: "我的咨询", action: #selector(myConsultAction))
        
        tableView.set(dataSource: self, delegate: self, rowHeight: UITableView.automaticDimension)
        tableView.register(cell: BindedDoctorsCell.self)
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
                    let imgView = emptyView.zz_add(subview: UIImageView(image: UIImage(named: "doctors_empty_img")))
                    let descLabel = emptyView.zz_add(subview: UILabel(text: "您还未绑定医生", font: .size(14), textColor: .c6, textAlignment: .center))
                    let buyBtn = emptyView.zz_add(subview: UIButton(title: "立即绑定", font: .size(18), titleColor: .cff9a21, backgroundColor: .cf, target: self, action: #selector(self.scan)))
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
extension BindedDoctorsController {
    @objc private func myConsultAction() {
        let vc = ConsultController()
        push(vc)
    }
    
    @objc private func scan() {
        let vc = QRCodeScanController()
        push(vc)
    }
}
// MARK: - Delegate Internal

// MARK: -
extension BindedDoctorsController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataSourceProperty.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(cell: BindedDoctorsCell.self, for: indexPath)
        let model = viewModel.dataSourceProperty.value[indexPath.row]
        
        cell.iconView.kf.setImage(with: URL(string: model.imgUrl), placeholder: UIImage(named: "doctor_avator"))
        cell.nameLabel.text = model.realName.isEmpty ? " " : model.realName
        cell.professionLabel.text = model.titleName
        cell.hospitalLabel.text = model.hospitalName
        
        var sers = [String]()
        for ser in model.doctorSers {
            sers.append(ser.serName)
        }
//        cell.servicesLabel.attributedText = viewModel.getServices(model: model) //sers.isEmpty ? "暂未开通任何服务" : sers.joined(separator: " ")
        cell.services = sers
//        cell.professionLabel.snpUpdateWidth()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = viewModel.dataSourceProperty.value[indexPath.row]
        let vc = DoctorDetailController()
        vc.viewModel.did = model.duid
        push(vc)
    }
}

