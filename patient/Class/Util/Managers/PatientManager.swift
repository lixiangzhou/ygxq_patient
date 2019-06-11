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
        getCachedPatientInfo()
    }
    
    var isLogin: Bool {
        return patientInfoModel != nil
    }
    
    var id: Int {
        return patientInfoModel?.id ?? 0
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
            self.patientInfoModel = nil
            return true
        } catch {
            return false
        }
    }
    
    @discardableResult
    func getCachedPatientInfo() -> PatientInfoModel? {
        if let jsonString = try? String(contentsOfFile: patientInfoPath) {
            self.patientInfoModel = PatientInfoModel.deserialize(from: jsonString)
            return self.patientInfoModel
        } else {
            return nil
        }
    }
    
}
