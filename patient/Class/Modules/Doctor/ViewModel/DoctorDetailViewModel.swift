//
//  DoctorDetailViewModel.swift
//  patient
//
//  Created by lixiangzhou on 2019/8/28.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift

class DoctorDetailViewModel: BaseViewModel {
    var did = 0
    
    let dataSourceProperty = MutableProperty<[Model]>([Model.docInfo(docInfo: DoctorInfoModel(), sers: [DoctorSerModel]())])
    let showBottomProperty = MutableProperty<Bool>(false)
    var sersDataSource = [DoctorSerModel]()
    var longSersDataSource = [DoctorSerModel]()
    let priceProperty = MutableProperty<NSAttributedString>(NSAttributedString())
    
    func getDocInfo() {
        DoctorApi.doctorInfo(duid: did).rac_responseModel(DoctorInfoModel.self).skipNil().startWithValues { [weak self] (model) in
            self?.refreshDocInfo(model, serModels: nil)
        }
    }
    
    func getSers() {
        DoctorApi.serList(duid: did, puid: patientId).rac_responseModel([DoctorSerModel].self).skipNil().startWithValues { [weak self] (list) in
            var sers1 = [DoctorSerModel]()
            var sers2 = [DoctorSerModel]()
            for m in list {
                if m.serType.hasPrefix("UTOPIA") {
                    if m.serType != "UTOPIA17" {                    
                        sers1.append(m)
                    }
                } else {
                    sers2.append(m)
                }
            }
            
            self?.refreshDocInfo(nil, serModels: sers1)
            self?.refreshSers(sers2)
            self?.showBottomProperty.value = !sers2.isEmpty
        }
    }
    
    func getOrder(_ completion: @escaping (Int?) -> Void) {
        if let model = getSelectedLongSer() {
            UIApplication.shared.beginIgnoringInteractionEvents()
            ServiceApi.buyPersonalService(duid: did, puid: patientId, serLongId: model.serType, price: model.serPrice, productName: model.serName).rac_responseModel([String: Any].self).startWithValues { (result) in
                UIApplication.shared.endIgnoringInteractionEvents()
                if let orderId = result?["orderId"] as? Int {
                    completion(orderId)
                } else {
                    completion(nil)
                }
            }
        } else {
            completion(nil)
        }
    }
    
    private func refreshSers(_ sers: [DoctorSerModel]) {
        var values = dataSourceProperty.value
        // 删除服务内容
        values.removeAll { (model) -> Bool in
            switch model {
            case .sersAction: return true
            default: return false
            }
        }
        
        // 更新服务内容
        var temp = [Model]()
        if var ser = sers.first {
            ser.selected = true
            priceProperty.value = getLongSerTitle(ser)
            var sers = sers
            sers.replaceSubrange(0...0, with: [ser])
            temp.append(.sersAction(title: "长期服务", sers: sers, msg: ser.serSummary))
            values.insert(contentsOf: temp, at: 1)
            dataSourceProperty.value = values
        }
    }
    
    private func refreshDocInfo(_ docModel: DoctorInfoModel?, serModels: [DoctorSerModel]?) {
        // 获取原医生信息
        var values = dataSourceProperty.value
        let idx = values.firstIndex(where: { (model) -> Bool in
            switch model {
            case .docInfo: return true
            default: return false
            }
        })
        
        // 更新医生信息
        if let idx = idx {
            switch values[idx] {
            case let .docInfo(docInfo: docInfo, sers: sers):
                if let docModel = docModel {
                    values.replaceSubrange(idx...idx, with: [Model.docInfo(docInfo: docModel, sers: sers)])
                }
                if let serModels = serModels {
                    values.replaceSubrange(idx...idx, with: [Model.docInfo(docInfo: docInfo, sers: serModels)])
                }
            default: break
            }
        }
        
        if let docModel = docModel {
            // 移除底部医生信息
            values.removeAll { (model) -> Bool in
                switch model {
                case .docInfoMsg: return true
                default: return false
                }
            }
            
            // 更新底部医生信息
            var msgs = [Model]()
            if !docModel.majorIn.isEmpty {
                msgs.append(.docInfoMsg(title: "专业擅长", txt: docModel.majorIn, showMore: false))
            }
            
            if !docModel.summary.isEmpty {
                msgs.append(.docInfoMsg(title: "职业履历", txt: docModel.summary, showMore: false))
            }
            
            if !msgs.isEmpty {
                values.append(contentsOf: msgs)
            }
        }
        
        dataSourceProperty.value = values
    }
    
    func getSerLayout(_ sers: [DoctorSerModel]) -> (UICollectionViewFlowLayout, CGFloat) {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 70, height: 100)
        let width: CGFloat = UIScreen.zz_width - (15 + 30) * 2
        
        if sers.count == 0 {
            return (layout, 0)
        } else if sers.count == 2 {
            let paddingX = (width - layout.itemSize.width * 2) / 4
            layout.sectionInset = UIEdgeInsets(top: 0, left: paddingX, bottom: 0, right: paddingX)
            layout.minimumInteritemSpacing = paddingX * 2
            return (layout, layout.itemSize.height)
        } else {
            let paddingX = (width - layout.itemSize.width * 3) / 6
            layout.sectionInset = UIEdgeInsets(top: 0, left: paddingX, bottom: 0, right: paddingX)
            layout.minimumInteritemSpacing = paddingX * 2
            return (layout, layout.itemSize.height)
        }
        
//        switch sers.count {
//        case 0:
//            return (layout, 0)
//        case 1:
//            let paddingX = (width - layout.itemSize.width) / 2
//            layout.sectionInset = UIEdgeInsets(top: 0, left: paddingX, bottom: 0, right: paddingX)
//            return (layout, layout.itemSize.height)
//        case 2:
//            let paddingX = (width - layout.itemSize.width * 2) / 4
//            layout.sectionInset = UIEdgeInsets(top: 0, left: paddingX, bottom: 0, right: paddingX)
//            layout.minimumInteritemSpacing = paddingX * 2
//            return (layout, layout.itemSize.height)
//        case 3:
//            let paddingX = (width - layout.itemSize.width * 3) / 6
//            layout.sectionInset = UIEdgeInsets(top: 0, left: paddingX, bottom: 0, right: paddingX)
//            layout.minimumInteritemSpacing = paddingX * 2
//            return (layout, layout.itemSize.height)
//        default:
//            let paddingX = (width - layout.itemSize.width * 4) / 8
//            layout.minimumInteritemSpacing = paddingX * 2
//            layout.minimumLineSpacing = 0
//            return (layout, layout.itemSize.height * ceil(CGFloat(sers.count) / 4))
//        }
    }
    
    func getLongSerLayout(_ sers: [DoctorSerModel]) -> (UICollectionViewFlowLayout, CGFloat) {
        let layout = UICollectionViewFlowLayout()
        let width: CGFloat = UIScreen.zz_width - (15 + 15) * 2
        
        let itemHeight: CGFloat = 35
        let spacing: CGFloat = 10
        switch sers.count {
        case 0:
            return (layout, 0)
        case 1:
            layout.itemSize = CGSize(width: width, height: itemHeight)
            return (layout, itemHeight)
        case 2:
            let itemWidth = (width - spacing) / 2
            layout.minimumInteritemSpacing = spacing
            layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
            return (layout, itemHeight)
        default:
            let itemWidth = (width - spacing * 2) / 3
            layout.minimumInteritemSpacing = spacing
            layout.minimumLineSpacing = spacing
            layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
            let row = ceil(CGFloat(sers.count) / 3)
            return (layout, itemHeight * row + (row - 1) * spacing)
        }
    }
    
    func getSerImg(_ model: DoctorSerModel) -> UIImage? {
        switch model.serType {
        case "UTOPIA17":
            return UIImage(named: "service_sunnydrug")
        case "UTOPIA15":
            return UIImage(named: "service_video")
        case "UTOPIA10":
            return UIImage(named: "service_tel")
        default: return nil
        }
    }
    
    func getLongSerTitle(_ model: DoctorSerModel) -> NSAttributedString {
        var unit = "月"
        switch model.indate {
        case 1:
            unit = "月"
        case 3:
            unit = "季"
        case 12:
            unit = "年"
        default:
            unit = "\(model.indate)月"
        }
        let attr = NSMutableAttributedString(attributedString: model.serPrice.bottomPayPriceString)
        attr.append(NSAttributedString(string: "元/\(unit)", attributes: [NSAttributedString.Key.font: UIFont.boldSize(17)]))
        return attr
    }
    
    func selectLongSer(index: Int) {
        var values = [DoctorSerModel]()

        var msgs = ""
        for (idx, model) in longSersDataSource.enumerated() {
            let selected = idx == index
            var model = model
            model.selected = selected
            if selected {
                priceProperty.value = getLongSerTitle(model)
                msgs = model.serSummary
            }
            values.append(model)
        }

        var datas = dataSourceProperty.value

        let idx1 = datas.firstIndex { (model) -> Bool in
            switch model {
            case .sersAction: return true
            default: return false
            }
        }

        if let idx1 = idx1 {
            datas.replaceSubrange(idx1...idx1, with: [.sersAction(title: "长期服务", sers: values, msg: msgs)])
        }

        dataSourceProperty.value = datas
    }
    
    func getSelectedLongSer() -> DoctorSerModel? {
        for m in longSersDataSource {
            if m.selected {
                return m
            }
        }
        return nil
    }
    
    func expendModel(model: Model, index: Int) {
        var values = dataSourceProperty.value
        switch model {
        case let .docInfoMsg(title: title, txt: txt, showMore: showMore):
            let m = Model.docInfoMsg(title: title, txt: txt, showMore: !showMore)
            values.replaceSubrange(index...index, with: [m])
        default:
            break
        }
        dataSourceProperty.value = values
    }
}

extension DoctorDetailViewModel {
    enum Model {
        case docInfo(docInfo: DoctorInfoModel, sers: [DoctorSerModel])
        case docInfoMsg(title: String, txt: String, showMore: Bool)
//        case serMsg(title: String, txt: String)
        case sersAction(title: String, sers: [DoctorSerModel], msg: String)
    }
}
