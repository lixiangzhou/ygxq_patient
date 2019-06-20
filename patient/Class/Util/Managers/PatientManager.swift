//
//  PatientManager.swift
//  patient
//
//  Created by Macbook Pro on 2019/6/6.
//Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift
import Result
import HandyJSON

/// 患者信息 信号量
let patientInfoProperty = MutableProperty<PatientInfoModel?>(nil)

/// 登录状态 信号量
let (_loginSignal, loginObserver) = Signal<Bool, NoError>.pipe()
let loginSignal = _loginSignal.skipRepeats()

var patientId: Int {
    return patientInfoProperty.value?.id ?? 0
}

class PatientManager {
    static let shared = PatientManager()
    
    private init() {
        patientInfoProperty.signal.observeValues { self.patientInfoModel = $0 }
        patientInfoProperty.value = getCachedPatientInfo()
        loginObserver.send(value: patientInfoModel != nil)
    }
    
    var isLogin: Bool {
        return patientInfoModel?.id != 0
    }
    
    var id: Int {
        return patientInfoModel?.id ?? 0
    }
    
    private let patientInfoPath = zz_filePath(with: .documentDirectory, fileName: "patientInfo")
    private (set) var patientInfoModel: PatientInfoModel? {
        didSet {
            if let pInfoModel = patientInfoModel {
                save(patient: pInfoModel)
            } else {
                deletePatientInfo()
            }
        }
    }
    
    func save(patient: PatientInfoModel) {
        if let jsonString = patient.toJSONString() {
            do {
                try jsonString.write(toFile: patientInfoPath, atomically: true, encoding: .utf8)
                print("保存 PatientInfoModel 成功")
            } catch {
                print("保存 PatientInfoModel 失败")
            }
        } else {
            print("保存 PatientInfoModel 失败")
        }
    }
    
    @discardableResult
    func deletePatientInfo() -> Bool {
        do {
            try FileManager.default.removeItem(atPath: patientInfoPath)
            print("删除用户成功")
            return true
        } catch {
            print("删除用户失败")
            return false
        }
    }
    
    @discardableResult
    func getCachedPatientInfo() -> PatientInfoModel? {
        if let jsonString = try? String(contentsOfFile: patientInfoPath) {
            return PatientInfoModel.deserialize(from: jsonString)
        } else {
            return nil
        }
    }
}

extension PatientManager {
    func getPatientInfo() {
        if isLogin {
            UserApi.patientInfo(pid: id).rac_responseModel(PatientInfoModel.self).startWithValues { (pInfo) in
                if let pInfo = pInfo {
                    JSONDeserializer.update(object: &patientInfoProperty.value!, from: pInfo.toJSONString())
                }
            }
        }
    }
}
