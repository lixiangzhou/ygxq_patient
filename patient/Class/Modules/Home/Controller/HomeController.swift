//
//  HomeController.swift
//  patient
//
//  Created by Macbook Pro on 2019/5/21.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import Moya

class HomeController: BaseController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        print(PatientManager.shared.patientInfoModel)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        RCManager.shared.connect()
//        present(BaseNavigationController(rootViewController: LoginController()), animated: true, completion: nil)
    }
}
