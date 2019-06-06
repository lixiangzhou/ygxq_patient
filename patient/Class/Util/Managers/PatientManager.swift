//
//  PatientManager.swift
//  patient
//
//  Created by Macbook Pro on 2019/6/6.
//Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class PatientManager {
    static let shared = PatientManager()
    
    private init() {
        patientInfoModel = getCachedPatientInfo()
    }
    
    static var isLogin: Bool {
        return shared.patientInfoModel != nil
    }
    
    private let patientInfoPath = zz_filePath(with: .documentDirectory, fileName: "patientInfo")
    private(set) var patientInfoModel: PatientInfoModel?
    
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
            return true
        } catch {
            return false
        }
    }
    
    func getCachedPatientInfo() -> PatientInfoModel? {
        if let jsonString = try? String(contentsOfFile: patientInfoPath) {
            return PatientInfoModel.deserialize(from: jsonString)
        } else {
            return nil
        }
    }
    
}
