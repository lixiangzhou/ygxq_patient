//
//  HomeController.swift
//  patient
//
//  Created by Macbook Pro on 2019/5/21.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class HomeController: BaseController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(PatientManager.shared.patientInfoModel)
        
        
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let vc = UploadResourceController()
        push(vc)
    }
}
