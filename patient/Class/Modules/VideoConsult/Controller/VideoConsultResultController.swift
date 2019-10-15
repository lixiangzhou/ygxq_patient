//
//  VideoConsultResultController.swift
//  patient
//
//  Created by lixiangzhou on 2019/8/15.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift

class VideoConsultResultController: BaseController {

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "视频咨询"
        setUI()
        setBinding()
        viewModel.getVideoData()
    }

    // MARK: - Public Property
    let viewModel = VideoConsultResultViewModel()
    
    // MARK: - Private Property
    private let tableView = UITableView()
    private let bottomView = UIView()
}

// MARK: - UI
extension VideoConsultResultController {
    override func setUI() {
        tableView.set(dataSource: self, delegate: self, separatorStyle: .none, rowHeight: UITableView.automaticDimension)
        tableView.register(cell: VideoConsultDocInfoCell.self)
        tableView.register(cell: VideoConsultPatientInfoCell.self)
        tableView.register(cell: VideoConsultDiseaseCell.self)
        tableView.register(cell: VideoConsultPicCell.self)
        tableView.register(cell: VideoConsultTimeCell.self)
        tableView.register(cell: VideoConsultArrowCell.self)
        tableView.backgroundColor = .cf0efef
        view.addSubview(tableView)
        
        let tipView = bottomView.zz_add(subview: UIButton(title: "提醒医生", font: .boldSize(17), titleColor: .cf, backgroundColor: .c407cec, target: self, action: #selector(tipAction)))
        let serviceView = bottomView.zz_add(subview: UIButton(title: "联系客服", font: .boldSize(17), titleColor: .cf, backgroundColor: UIColor.cffa84c, target: self, action: #selector(serviceAction)))
        
        view.addSubview(bottomView)
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        bottomView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
            make.bottomOffsetFrom(self)
        }
        
        tipView.snp.makeConstraints { (make) in
            make.top.left.bottom.equalToSuperview()
        }
        
        serviceView.snp.makeConstraints { (make) in
            make.top.right.bottom.equalToSuperview()
            make.width.equalTo(tipView)
            make.left.equalTo(tipView.snp.right)
        }
    }
    
    override func setBinding() {
        tableView.reactive.reloadData <~ viewModel.dataSourceProperty.signal.map(value: ())
        
        viewModel.showBottomProperty.producer.startWithValues { [weak self] (show) in
            guard let self = self else { return }
            self.bottomView.isHidden = !show
            self.tableView.contentInset.bottom = show ? 50 : 0
        }
    }
}

// MARK: - Action
extension VideoConsultResultController {
    @objc private func tipAction() {
        viewModel.remindDoctor()
    }
    
    @objc private func serviceAction() {
        UIApplication.shared.open(URL(string: "tel://4006251120")!, options: [:], completionHandler: nil)
    }
}

// MARK: - Delegate Internal

// MARK: -
// MARK: - UITableViewDataSource, UITableViewDelegate
extension VideoConsultResultController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataSourceProperty.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = viewModel.dataSourceProperty.value[indexPath.row]
        
        switch model {
        case let .docinfo(model: docModel):
            let cell = tableView.dequeue(cell: VideoConsultDocInfoCell.self, for: indexPath)
            
            cell.iconView.kf.setImage(with: URL(string: docModel.imgUrl), placeholder: UIImage(named: "doctor_avator"))
            cell.nameLabel.text = docModel.realName.isEmpty ? " " : docModel.realName
            cell.professionLabel.text = docModel.titleName
            cell.hospitalLabel.text = docModel.hospitalName
            cell.professionLabel.snpUpdateWidth()
            
            return cell
        case let .patient(model: serModel):
            let cell = tableView.dequeue(cell: VideoConsultPatientInfoCell.self, for: indexPath)
            
            cell.nameView.rightLabel.text = serModel.realName
            cell.mobileView.rightLabel.text = serModel.mobile.mobileSecrectString
            cell.idView.rightLabel.text = serModel.idCardNo.idSecrectString
            
            return cell
        case let .disease(disease: disease):
            let cell = tableView.dequeue(cell: VideoConsultDiseaseCell.self, for: indexPath)
            cell.diseaseLabel.text = disease
            return cell
            
        case let .picture(pics: pics):
            let cell = tableView.dequeue(cell: VideoConsultPicCell.self, for: indexPath)
            cell.dataSource = pics
            return cell
            
        case .exam:
            let cell = tableView.dequeue(cell: VideoConsultArrowCell.self, for: indexPath)
            cell.innerView.leftLabel.text = "查看随访问卷"
            return cell
        case .lookPics:
            let cell = tableView.dequeue(cell: VideoConsultArrowCell.self, for: indexPath)
            cell.innerView.leftLabel.text = "查看完善资料"
            return cell
            
        case let .time(model: videoModel):
            let cell = tableView.dequeue(cell: VideoConsultTimeCell.self, for: indexPath)
            cell.setData(videoModel)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = viewModel.dataSourceProperty.value[indexPath.row]
        
        switch model {
        case .exam:
            let vc = FUVistExamListController()
            vc.title = "查看随访问卷"
            vc.viewModel.type = .videolookLinkId(linkId: viewModel.vid)
            push(vc)
        case .lookPics:
            let vc = PictureListController()
            vc.title = "查看完善资料"
            vc.viewModel.type = .videoOrDrugDetail(linkId: viewModel.vid, serType: "UTOPIA15", imgType: 0)
            push(vc)
        default: break
        }
    }
}
