//
//  HomeController.swift
//  patient
//
//  Created by Macbook Pro on 2019/5/21.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit

import Moya

enum PatientApi {
    case queryPatientsByBindingDoctor(duid: Int)
}

extension PatientApi: TargetType {
    var path: String {
        switch self {
        case .queryPatientsByBindingDoctor:
            return "/patient/queryPatientsByBindingDoctor"
            
        }
    }
    
    var task: Task {
        var params = [String: Any]()
        switch self {
        case let .queryPatientsByBindingDoctor(duid: duid):
            params["duid"] = duid
        }
        
        return .requestParameters(parameters: params, encoding: JSONEncoding.default)
    }
}


class HomeController: BaseController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(PatientManager.shared.patientInfoModel)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let vc = AddressListController()
//        push(vc)
//        SelectDistrictView().show()
        
//        RCManager.shared.connect()
        
        PatientApi.queryPatientsByBindingDoctor(duid: 28146).rac_responseModel([PatientInfoModel].self).startWithValues { (patients) in
//            print(patients)
        }
    }
}

