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

/// 患者信息 信号量
let patientInfoProperty = MutableProperty<PatientInfoModel?>(nil)
/// 登录状态 信号量
let (loginSignal, loginObserver) = Signal<Bool, NoError>.pipe()

class PatientManager {
    static let shared = PatientManager()
    
    private init() {
        patientInfoModel = getCachedPatientInfo()
        
        patientInfoProperty.value = patientInfoModel
        
        loginObserver.send(value: patientInfoModel != nil)
    }
    
    var isLogin: Bool {
        return patientInfoModel != nil
    }
    
    var id: Int {
        return patientInfoModel?.id ?? 0
    }
    
    private let patientInfoPath = zz_filePath(with: .documentDirectory, fileName: "patientInfo")
    private(set) var patientInfoModel: PatientInfoModel? {
        didSet {
            patientInfoProperty.value = patientInfoModel
        }
    }
    
    func save(patient: PatientInfoModel) {
        if let jsonString = patient.toJSONString() {
            do {
                try jsonString.write(toFile: patientInfoPath, atomically: true, encoding: .utf8)
                patientInfoModel = patient
            } catch {
                patientInfoModel = nil
            }
        } else {
            patientInfoModel = nil
        }
    }
    
    @discardableResult
    func deletePatientInfo() -> Bool {
        do {
            try FileManager.default.removeItem(atPath: patientInfoPath)
            patientInfoModel = nil
            return true
        } catch {
            return false
        }
    }
    
    @discardableResult
    func getCachedPatientInfo() -> PatientInfoModel? {
        if let jsonString = try? String(contentsOfFile: patientInfoPath) {
            patientInfoModel = PatientInfoModel.deserialize(from: jsonString)
            return patientInfoModel
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
                    patientInfoProperty.value = pInfo
                }
            }
        }
    }
}
