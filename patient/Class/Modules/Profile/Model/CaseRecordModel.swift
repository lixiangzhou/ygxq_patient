//
//  CaseRecordModel.swift
//  patient
//
//  Created by Macbook Pro on 2019/6/21.
//  Copyright © 2019 sphr. All rights reserved.
//

import Foundation

struct CaseRecordModel: ModelProtocol, Equatable {
    var id: Int = 0
    var chiefComplaint: String = ""
    var outTime: TimeInterval = 0
    var familyHis: String = ""
    var presentIllnessHis: String = ""
    var clinicHospital: String = ""
    var sourceType: Int = 0
    var clinicTime: TimeInterval = 0
    var dischargeInstructions: String = ""
    var personalHis: String = ""
    var puid: Int = 0
    var preDiagnosis: String = ""
    var createTime: TimeInterval = 0
    var serType: String = ""
    var previousHis: String = ""
    var hlrRecordId: Int = 0
    var auid: Int = 0
    var type: Int = 0
    
    var ops: [OPS] = []
    var imgs: [ImageModel] = []
    
    struct OPS: ModelProtocol, Equatable {
        var id = 0
        var caseHisId = 0
        var opName = ""
        var opTime: TimeInterval = 0
        var createTime: TimeInterval = 0
        var opas: [OPAS] = []
    }
    
    struct OPAS: ModelProtocol, Equatable, FourColumnViewModelProtocol {
        var opId: Int = 0
        var stenosisDegree: String = ""
        var id: Int = 0
        var part: String = ""
        var collateralBranch: String = ""
        var lesionsNature: String = ""
        var createTime: TimeInterval = 0
   
        var c1String: String {
            return part
        }
        
        var c2String: String {
            return lesionsNature
        }
        
        var c3String: String {
            return stenosisDegree
        }
        
        var c4String: String {
            return collateralBranch
        }
    }
}

struct ImageModel: ModelProtocol, Equatable {
    var id = 0
    var url = ""
    var mediaUrl = ""
}
