//
//  DoctorDetailController.swift
//  patient
//
//  Created by lixiangzhou on 2019/8/28.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift

class DoctorDetailController: BaseController {

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "医生详情页"
        setUI()
        setBinding()
        viewModel.getDocInfo()
        viewModel.getSers()
    }

    // MARK: - Public Property
    let viewModel = DoctorDetailViewModel()
    // MARK: - Private Property
    private let tableView = UITableView()
    private let bottomView = PayBottomView()
}

// MARK: - UI
extension DoctorDetailController {
    override func setUI() {
        tableView.backgroundColor = .cf0efef
        
        tableView.set(dataSource: self, delegate: nil, rowHeight: UITableView.automaticDimension)
        tableView.register(cell: DoctorDetailInfoCell.self)
        tableView.register(cell: DoctorDetailActionsCell.self)
        tableView.register(cell: DoctorDetailMsgCell.self)
        tableView.register(cell: DoctorDetailMsgExpendableCell.self)
        tableView.estimatedRowHeight = 200
        view.addSubview(tableView)
        
        bottomView.payClosure = { [weak self] in
            UIApplication.shared.beginIgnoringInteractionEvents()
            self?.viewModel.getOrder({ (orderId) in
                UIApplication.shared.endIgnoringInteractionEvents()
                if let orderId = orderId {
                    let vc = PayController()
                    vc.viewModel.orderId = orderId
                    vc.viewModel.resultAction = PayViewModel.ResultAction(backClassName: self?.zz_className ?? "DoctorDetailController", type: .longSer)
                    self?.push(vc)
                }
            })
        }
        view.addSubview(bottomView)
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        bottomView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(bottomView.zz_height)
            make.bottomOffsetFrom(self)
        }
    }
    
    override func setBinding() {
        tableView.reactive.reloadData <~ viewModel.dataSourceProperty.signal.map(value: ())
        
        viewModel.showBottomProperty.producer.startWithValues { [weak self] (show) in
            guard let self = self else { return }
            self.bottomView.isHidden = !show
            self.tableView.contentInset.bottom = show ? self.bottomView.zz_height : 0
        }
        
        viewModel.priceProperty.signal.observeValues { [weak self] (price) in
            self?.bottomView.priceLabel.text = price
        }
    }
}

// MARK: - Delegate Internal

// MARK: -
extension DoctorDetailController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataSourceProperty.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = viewModel.dataSourceProperty.value[indexPath.row]
        
        switch model {
        case let .docInfo(docInfo: model, sers: sers):
            let cell = tableView.dequeue(cell: DoctorDetailInfoCell.self, for: indexPath)
            cell.iconView.kf.setImage(with: URL(string: model.imgUrl), placeholder: UIImage(named: "doctor_avator"))
            cell.nameLabel.text = model.realName.isEmpty ? " " : model.realName
            cell.professionLabel.text = model.titleName
            cell.hospitalLabel.text = model.hospitalName
            
            cell.serView.dataSource = self
            cell.serView.delegate = self
            cell.serView.tag = SersViewType.ser.rawValue
            viewModel.sersDataSource = sers
            let (layout, height) = viewModel.getSerLayout(sers)
            cell.serView.setCollectionViewLayout(layout, animated: false)
            cell.serView.snp.updateConstraints { (make) in
                make.height.equalTo(height)
            }
            cell.serView.reloadData()
            return cell
        case let .sersAction(title: title, sers: sers):
            let cell = tableView.dequeue(cell: DoctorDetailActionsCell.self, for: indexPath)
            cell.titleLabel.text = title
            cell.serView.dataSource = self
            cell.serView.delegate = self
            cell.serView.tag = SersViewType.longSer.rawValue
            viewModel.longSersDataSource = sers
            let (layout, height) = viewModel.getLongSerLayout(sers)
            cell.serView.setCollectionViewLayout(layout, animated: false)
            cell.serView.snp.updateConstraints { (make) in
                make.height.equalTo(height)
            }
            cell.serView.reloadData()
            return cell
        case let .docInfoMsg(title: title, txt: txt, showMore: showMore):
            let cell = tableView.dequeue(cell: DoctorDetailMsgExpendableCell.self, for: indexPath)
            cell.titleLabel.text = title
            let style = NSMutableParagraphStyle()
            style.lineSpacing = 2
            cell.txtLabel.attributedText = NSAttributedString(string: txt, attributes: [NSAttributedString.Key.font: UIFont.size(14), NSAttributedString.Key.paragraphStyle: style])
            cell.addMore()
            cell.updateConstraint(expend: showMore)
            cell.expendAction = { [weak self] expend in
                self?.viewModel.expendModel(model: model, index: indexPath.row)
            }
            return cell
        case let .serMsg(title: title, txt: txt):
            let cell = tableView.dequeue(cell: DoctorDetailMsgCell.self, for: indexPath)
            cell.titleLabel.text = title
            cell.txtLabel.text = txt
            return cell
        }
    }
}

extension DoctorDetailController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch SersViewType(rawValue: collectionView.tag)! {
        case .ser:
            return viewModel.sersDataSource.count
        case .longSer:
            return viewModel.longSersDataSource.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch SersViewType(rawValue: collectionView.tag)! {
        case .ser:
            let cell = collectionView.dequeue(cell: DoctorDetailInfoCell.SerCell.self, for: indexPath)
            let model = viewModel.sersDataSource[indexPath.row]
            cell.imgView.image = viewModel.getSerImg(model)
            cell.titleLabel.text = model.serName
            return cell
        case .longSer:
            let cell = collectionView.dequeue(cell: DoctorDetailActionsCell.SerCell.self, for: indexPath)
            let model = viewModel.longSersDataSource[indexPath.row]
            cell.txtLabel.text = viewModel.getLongSerTitle(model)
            cell.txtLabel.backgroundColor = model.selected ? UIColor.cf25555.withAlphaComponent(0.2) : .cf
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch SersViewType(rawValue: collectionView.tag)! {
        case .ser:
            let model = viewModel.sersDataSource[indexPath.row]
            switch model.serType {
            case "UTOPIA15":
                let vc = VideoConsultBuyController()
                vc.viewModel.did = model.duid
                vc.viewModel.serType = model.serType
                push(vc)
            case "UTOPIA16":
                let vc = SunnyDrugBuyController()
                vc.viewModel.did = model.duid
                vc.viewModel.serType = model.serType
                push(vc)
            default: break
            }
        case .longSer:
            viewModel.selectLongSer(index: indexPath.item)
        }
    }
}

extension DoctorDetailController {
    enum SersViewType: Int {
        case ser
        case longSer
    }
}
