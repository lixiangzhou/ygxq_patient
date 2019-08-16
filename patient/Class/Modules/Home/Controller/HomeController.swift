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
        print(TimeInterval(100000).toTime(format: "mm:ss"))
        print((Date().timeIntervalSince1970 * 1000).toTime(format: "yyyy-MM-dd HH:mm:ss"))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        RCManager.shared.connect()
//        present(BaseNavigationController(rootViewController: LoginController()), animated: true, completion: nil)
        
//        UIApplication.shared.open(URL(string: "telprompt://13300000008")!, options: [:], completionHandler: nil)
//        UIApplication.shared.openURL(URL(string: "tel:13300000008")!)
        print(SettingController.className)
    }
}
