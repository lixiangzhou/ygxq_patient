//
//  HealthDataMemberEditViewModel.swift
//  patient
//
//  Created by lixiangzhou on 2019/10/14.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift

class HealthDataMemberEditViewModel: BaseViewModel {
    var mode = Mode.add
    var model: HealthDataECGPatientModel!
    let sexDataSource = CommonPicker.DataSouce.one(["男", "女"])
    
    let saveResultProperty = MutableProperty<Bool>(false)
    
    func save(name: String, sex: Int, birth: TimeInterval, isDefault: String) {
        var params = [String: Any]()
        params["realName"] = name
        params["sex"] = sex
        params["birth"] = birth
        params["isDefault"] = isDefault
        params["puid"] = patientId
        
        switch mode {
        case .add:
            CommonApi.addUsrPatientConsultant(params: params).rac_response(String.self).startWithValues { [weak self] (resp) in
                self?.saveResultProperty.value = resp.isSuccess
                HUD.showError(BoolString(resp))
            }
        case .edit:
            params["id"] = model.id
            params["createTime"] = model.createTime
            params["isDelete"] = "N"
            
            CommonApi.updateUsrPatientConsultant(params: params).rac_response(String.self).startWithValues { [weak self] (resp) in
                self?.saveResultProperty.value = resp.isSuccess
                HUD.showError(BoolString(resp))
            }
        }
    }
    
    func delete() {
        var params = [String: Any]()
        params["realName"] = model.realName
        params["sex"] = model.sex
        params["birth"] = model.birth
        params["isDefault"] = model.isDefault
        params["puid"] = patientId
        params["id"] = model.id
        params["createTime"] = model.createTime
        params["isDelete"] = "Y"
        
        CommonApi.updateUsrPatientConsultant(params: params).rac_response(String.self).startWithValues { [weak self] (resp) in
            self?.saveResultProperty.value = resp.isSuccess
            HUD.showError(BoolString(resp))
        }
    }
}

extension HealthDataMemberEditViewModel {
    var defaultArrowTextColor: UIColor {
        switch mode {
        case .add:
            return .c9
        case .edit:
            return .c3
        }
    }
    
    var nameAttr: NSAttributedString {
        switch mode {
        case .add:
            return "姓名".needed(with: .size(14), color: .c3)
        case .edit:
            return NSAttributedString(string: "姓名", attributes: [NSAttributedString.Key.foregroundColor: UIColor.c3, NSAttributedString.Key.font: UIFont.size(14)])
        }
    }
    
    var sexAttr: NSAttributedString {
        switch mode {
        case .add:
            return "性别".needed(with: .size(14), color: .c3)
        case .edit:
            return NSAttributedString(string: "性别", attributes: [NSAttributedString.Key.foregroundColor: UIColor.c3, NSAttributedString.Key.font: UIFont.size(14)])
        }
    }
    
    var birthAttr: NSAttributedString {
        switch mode {
        case .add:
            return "出生日期".needed(with: .size(14), color: .c3)
        case .edit:
            return NSAttributedString(string: "出生日期", attributes: [NSAttributedString.Key.foregroundColor: UIColor.c3, NSAttributedString.Key.font: UIFont.size(14)])
        }
    }
    
    var title: String {
        switch mode {
        case .add:
            return "完善个人信息"
        case .edit:
            return "编辑信息"
        }
    }
}

extension HealthDataMemberEditViewModel {
    enum Mode {
        case add, edit
    }
}
