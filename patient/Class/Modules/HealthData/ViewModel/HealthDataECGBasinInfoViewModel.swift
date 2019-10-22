//
//  HealthDataECGBasinInfoViewModel.swift
//  patient
//
//  Created by lixiangzhou on 2019/10/14.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift

class HealthDataECGBasinInfoViewModel: BaseViewModel {
    let orderInfoProperty = MutableProperty<[HealthDatECGOrderInfoModel]>([])
    
    var ecgMode = "0"
    
    let topInfoAttrProperty = MutableProperty<NSAttributedString?>(nil)
    
    let selectPatientInfoProperty = MutableProperty<HealthDataECGPatientModel?>(nil)
    
    var backClass: String?
    
    var selectMode = SelectMode.add
    
    var selectPatientInfo: HealthDataECGPatientModel?
    
    override init() {
        super.init()
        
        orderInfoProperty.producer.startWithValues { [weak self] (models) in
            let defaultDict = [NSAttributedString.Key.foregroundColor: UIColor.c6]
            let colorDict = [NSAttributedString.Key.foregroundColor: UIColor.cffa84c]
            
            let attr = NSMutableAttributedString()
            if let model13 = models.first(where: { (model) -> Bool in
                return model.serCode == "UTOPIA13"
            }) {
                attr.append(NSMutableAttributedString(string: "您套餐剩余心电评估服务次数：", attributes: defaultDict))
                attr.append(NSAttributedString(string: "\(model13.surplusNum ?? 0)次", attributes: colorDict))
                let time = model13.dueDate?.toTime(format: "yyyy-MM-dd") ?? ""
                attr.append(NSAttributedString(string: "，有效期至\(time)", attributes: defaultDict))
            }
            
            if let model14 = models.first(where: { (model) -> Bool in
                model.serCode == "UTOPIA14"
            }) {
                if let num = model14.surplusNum {
                    attr.append(NSAttributedString(string: "\n您购买的单次心电评估服务次数剩余：", attributes: defaultDict))
                    attr.append(NSAttributedString(string: "\(num)次", attributes: colorDict))
                }
            }
                        
            self?.topInfoAttrProperty.value = attr
        }
    }
    
    func querySurpluNum() {
        ECGApi.querySurpluNum(pid: patientId).rac_responseModel([HealthDatECGOrderInfoModel].self).skipNil().startWithValues { [weak self] (models) in
            self?.orderInfoProperty.value = models
            
            self?.ecgMode = "0"
            for m in models {
                if (m.surplusNum ?? 0) > 0 {
                    self?.ecgMode = "1"
                    break
                }
            }
        }
    }
    
    func queryPatientConsultantList() {
        CommonApi.queryPatientConsultantList(pid: patientId).rac_responseModel([HealthDataECGPatientModel].self).skipNil().startWithValues { [weak self] (models) in
            guard let self = self else { return }
            switch self.selectMode {
            case .add:
                self.selectPatientInfo = models.first
                self.selectPatientInfoProperty.value = models.first
            case .select:
                if models.isEmpty {
                    self.selectPatientInfo = nil
                    self.selectPatientInfoProperty.value = nil
                } else {
                    if let model = self.selectPatientInfo {
                        let findModel = models.first(where: { (m) -> Bool in
                            return m.id == model.id
                        })
                        // 没有找到就默认一个 HealthDataECGPatientModel，表示选择的成员被删除了
                        self.selectPatientInfoProperty.value = findModel ?? HealthDataECGPatientModel()
                    }
                }
            }
            
            
//            if let models = models {
//                if let model = self?.selectPatientInfo {
//                    let findModel = models.first(where: { (m) -> Bool in
//                        return m.id == model.id
//                    })
//
//                    self?.selectPatientInfoProperty.value = findModel ?? models.first
//                } else {
//                    self?.selectPatientInfo = models.first
//                    self?.selectPatientInfoProperty.value = models.first
//                }
//            } else {
//                self?.selectPatientInfo = nil
//                self?.selectPatientInfoProperty.value = nil
//            }
        }
    }
    
    func checkToBuy(_ completion: @escaping (SunShineHutModel) -> Void) {
        ServiceApi.querySunshineHutList.rac_responseModel([SunShineHutModel].self).skipNil().startWithValues { (models) in
            if let model = models.first(where: { (m) -> Bool in
                return m.serCode == "UTOPIA14"
            }) {
                completion(model)
            }
        }
    }
    
    func addECG(params: [String: Any], completion: @escaping () -> ()) {
        ECGApi.addECG(params: params).rac_response(String.self).startWithValues { (resp) in
            completion()
            if resp.isSuccess {
                HUD.show(toast: "上传成功")
            }
        }
    }
}

extension HealthDataECGBasinInfoViewModel {
    enum SelectMode {
        case add, select
    }
}
